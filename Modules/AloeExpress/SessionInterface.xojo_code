#tag Interface
Protected Interface SessionInterface
	#tag Method, Flags = &h0
		Function SessionAllSessionIds() As String()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionGet(Request As AloeExpress.Request, AssignNewID As Boolean=True) As AloeExpress.Session
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionLookup(SessionId As String) As AloeExpress.Session
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionTerminate(Session As Dictionary)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
