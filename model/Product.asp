<%
Class Product
    Private id
    Private category_id
    Private product_title
    Private price
    Private discount
    Private thumbnail
    Private num
    
    ' Phương thức khởi tạo (Constructor)
    Public Sub Class_Initialize()
        id = ""
        category_id = ""
        product_title = ""
        price = ""
        discount = ""
        thumbnail = ""
        num = 0
    End Sub
    
    ' Thuộc tính Product ID
    Public Property Get ProductID()
        ProductID = id
    End Property
    Public Property Let ProductID(value)
        id = value
    End Property
    
    ' Thuộc tính Category ID
    Public Property Get CategoryID()
        CategoryID = category_id
    End Property
    Public Property Let CategoryID(value)
        category_id = value
    End Property
    
    ' Thuộc tính Product Title
    Public Property Get ProductTitle()
        ProductTitle = product_title
    End Property
    Public Property Let ProductTitle(value)
        product_title = value
    End Property
    
    ' Thuộc tính Price
    Public Property Get ProductPrice()
        ProductPrice = price
    End Property
    Public Property Let ProductPrice(value)
        price = value
    End Property
    
    ' Thuộc tính Thumbnail
    Public Property Get ProductThumbnail()
        ProductThumbnail = thumbnail
    End Property
    Public Property Let ProductThumbnail(value)
        thumbnail = value
    End Property
    
    ' Thuộc tính Number
    Public Property Get ProductNum()
        ProductNum = num
    End Property
    Public Property Let ProductNum(value)
        num = value
    End Property
End Class
%>
