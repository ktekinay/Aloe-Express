#tag Class
Protected Class RedisSessionEngine
Inherits Redis_MTC
Implements AloeExpress.SessionEngineInterface
	#tag Method, Flags = &h21
		Private Function GetSession(RedisKey As String) As AloeExpress.Session
		  Dim Session As AloeExpress.Session
		  
		  #Pragma BreakOnExceptions False
		  Try
		    Dim JSONString As String = self.Get(RedisKey)
		    Session = Session.FromJSONString(JSONString)
		    
		  Catch Err As KeyNotFoundException
		    // Wasn't found
		    
		  End Try
		  #Pragma BreakOnExceptions Default
		  
		  Return Session
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionAllSessionIds() As String()
		  // Get all the session Ids
		  Dim SessionIds() As String = Scan(kPrefix + "*")
		  
		  // Strip the internal prefix
		  For Index As Integer = 0 To SessionIds.Ubound
		    SessionIds(Index) = SessionIds(Index).Mid(kPrefix.Len + 1)
		  Next
		  
		  Return SessionIds
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionGet(Request As AloeExpress.Request, AssignNewID As Boolean=True) As AloeExpress.Session
		  Dim Session As AloeExpress.Session
		  
		  Dim OriginalSessionID As String = Request.Cookies.Lookup("SessionID", "")
		  Dim RedisKey As String = kPrefix + OriginalSessionID
		  
		  If OriginalSessionID <> "" Then
		    // Get the value if it's there
		    // Follow any redirects
		    Dim RedirectRedisKey As String
		    
		    Do
		       Session = GetSession(RedisKey)
		      If Session Is Nil Then
		        RedirectRedisKey = ""
		      Else
		        RedirectRedisKey = Session.Lookup("RedisRedirect", "")
		        If RedirectRedisKey <> "" Then
		          RedisKey = RedirectRedisKey
		        End If
		      End If
		    Loop Until RedirectRedisKey = ""
		  End If
		  
		  If Session Is Nil Then
		    // Create a new Session
		    Session = New AloeExpress.Session(Request)
		    
		    // Return it
		    Return Session
		  End If
		  
		  Session.RequestCount = Session.RequestCount + 1
		  
		  If AssignNewID Then
		    // Save the original Session
		    Dim OriginalSession As AloeExpress.Session = Session
		    Dim OriginalRedisKey As String = RedisKey
		    
		    // Make a new one
		    Session = New AloeExpress.Session(OriginalSession)
		    RedisKey = kPrefix + Session.SessionID
		    
		    // Redirect the original to the new one
		    OriginalSession.Value("RedisRedirect") = RedisKey
		    
		    // Save them both
		    SetMultiple(OriginalRedisKey : OriginalSession.ToJSONString, RedisKey : Session.ToJSONString)
		    
		    // Set expirations
		    Expire(OriginalRedisKey, SessionsTimeoutSecs * 1000)
		    Expire(RedisKey, SessionsTimeoutSecs * 1000)
		  End If
		  
		  Return Session
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionLookup(SessionId As String) As AloeExpress.Session
		  Dim RedisKey As String = kPrefix + SessionId
		  Dim Session As AloeExpress.Session = GetSession(RedisKey)
		  Return Session
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionSave(Session As AloeExpress.Session, Request As AloeExpress.Request)
		  Dim SessionID As String = Session.SessionID
		  Dim RedisKey As String = kPrefix + SessionID
		  
		  // Set the cookie expiration date.
		  Dim Now As New Date
		  Dim CookieExpiration As New Date(Now)
		  CookieExpiration.TotalSeconds = CookieExpiration.TotalSeconds + SessionsTimeOutSecs
		  
		  // Drop the SessionID cookie.
		  Request.Response.CookieSet("SessionID", SessionID, CookieExpiration)
		  
		  Session.LastRequestTimestamp = Now
		  Call Set(RedisKey, DictionaryToJSONString(Session), SessionsTimeoutSecs * 1000)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionTerminate(Session As AloeExpress.Session)
		  Dim RedisKey As String = kPrefix + Session.SessionID
		  Call Delete(RedisKey, True)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		SessionsTimeoutSecs As Integer = 600
	#tag EndProperty


	#tag Constant, Name = kPrefix, Type = String, Dynamic = False, Default = \"ae_sess:", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsConnected"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsPipeline"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastCommand"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastErrorCode"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LatencyMs"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RedisVersion"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ResultCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeoutSecs"
			Group="Behavior"
			InitialValue="30"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrackLatency"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
