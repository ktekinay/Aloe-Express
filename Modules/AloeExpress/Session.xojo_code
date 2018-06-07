#tag Class
Protected Class Session
Inherits Dictionary
	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Request As AloeExpress.Request)
		  Self.Constructor
		  
		  // Set the required Keys
		  SessionID = UUIDGenerate
		  LastRequestTimestamp = New Date
		  RemoteAddress = Request.RemoteAddress
		  UserAgent = Request.Headers.Lookup("User-Agent", "")
		  RequestCount = 1
		  Authenticated = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(CopyFromDictionary As Dictionary)
		  Self.Constructor
		  
		  Dim CopyKeys() As Variant = CopyFromDictionary.Keys
		  Dim CopyValues() As Variant = CopyFromDictionary.Values
		  
		  For Index As Integer = 0 To CopyKeys.Ubound
		    Value(CopyKeys(Index)) = CopyValues(Index)
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromJSONString(JSONString As String) As AloeExpress.Session
		  Dim Session As New AloeExpress.Session
		  
		  Dim JSON As JSONItem = AloeExpress.JSONStringToJSONItem(JSONString)
		  
		  For Each Name As String In JSON.Names
		    Session.Value(Name) = JSON.Value(Name)
		  Next
		  
		  Return Session
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(key As Variant, Assigns value As Variant)
		  // Notify anything using this class that a value has changed
		  
		  Super.Value(key) = value
		  RaiseEvent ValueChanged(key)
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ValueChanged(Key As Variant)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Lookup(kAuthenticated, False)
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value(kAuthenticated) = value
			  
			End Set
		#tag EndSetter
		Authenticated As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Lookup(kLastRequestTimestamp, Nil)
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value(kLastRequestTimestamp) = value
			  
			End Set
		#tag EndSetter
		LastRequestTimestamp As Date
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Lookup(kRemoteAddress, "")
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value(kRemoteAddress) = value
			End Set
		#tag EndSetter
		RemoteAddress As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Lookup(kRequestCount, 0)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value(kRequestCount) = value
			  
			End Set
		#tag EndSetter
		RequestCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Lookup(kSessionID, "")
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value(kSessionID) = value
			  
			End Set
		#tag EndSetter
		SessionID As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return AloeExpress.DictionaryToJSONString(Self)
			  
			  
			End Get
		#tag EndGetter
		ToJSONString As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Lookup(kUserAgent, "")
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value(kUserAgent) = value
			  
			End Set
		#tag EndSetter
		UserAgent As String
	#tag EndComputedProperty


	#tag Constant, Name = kAuthenticated, Type = String, Dynamic = False, Default = \"Authenticated", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kLastRequestTimestamp, Type = String, Dynamic = False, Default = \"LastRequestTimestamp", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kRemoteAddress, Type = String, Dynamic = False, Default = \"RemoteAddress", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kRequestCount, Type = String, Dynamic = False, Default = \"RequestCount", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kSessionID, Type = String, Dynamic = False, Default = \"SessionID", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kUserAgent, Type = String, Dynamic = False, Default = \"UserAgent", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="BinCount"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Authenticated"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
