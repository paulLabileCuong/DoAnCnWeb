                            <%
                                cmdPrep.CommandText = "SELECT * FROM OrderDetail WHERE order_id = " & rs("id") & ""
                                Set rs1 = cmdPrep.execute
                                do while not rs1.eof
                            %>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Tên sản phẩm</th>
                                            <th>Số lượng</th>
                                            <th>Giá</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><%=rs1("product_id")%></td>
                                            <td><%=rs1("price")%></td>
                                            <td><%=rs1("num")%></td>
                                        </tr>
                                    </tbody>
                                </table>
                            <%
                                rs1.MoveNext
                                loop
                            %>