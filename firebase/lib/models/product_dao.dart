class ProductDAO
{
  String? cve_product;
  String? description;
  String? img;

  ProductDAO({this.cve_product, this.description, this.img});
  
  Map<String, dynamic> toMap()
  {
    return
    {
      'cve_product': cve_product,
      'description': description,
      'img': img
    };
  }
}