class Database {
  static var sharedInstance = Database()
  lazy var contacts: [Contact] =
    [("Marc", "Jackson", "0032", "654321", "boy"),
     ("Jef", "Le Roy", "0052", "123456", "boy"),
     ("Phill", "Ivry", "0088", "098765", "boy"),
     ("Oscar", "O'Neil", "0032", "567890", "boy"),
     ("Penny", "Le Roy", "0052", "135792", "girl"),
     ("Maxime", "Defauw", "0088", "246801", "boy"),
     ("Ray", "Wenderlich", "0032", "114527", "boy"),
     ("Violette", "Le Roy", "0052", "562283", "girl"),
     ("", "Bentham", "0088", "778467", "unknown"),
     ("Sebastian", "Bommer", "0043", "978786", "boy"),
     ("Charlotte", "Sky", "0052", "123444", "girl"),
     ("Thomas", "Valette", "0088", "946733", "boy"),
     ("Claire", "Graham", "0088", "090987", "girl"),
     ("Valeria", "Flower", "0088", "655473", "girl"),
     ("Jullie", "Closs", "0074", "128876", "girl"),
     ("Junior", "Resp", "0074", "145836", "boy"),
     ("Eddie", "Broe", "0022", "673698", "boy"),
     ("Charise", "Ivry", "0022", "0936798", "girl"),
     ("Sal", "Addis", "0022", "783940", "boy"),
     ("Bebe", "Cashwell", "0032", "264826", "girl"),
     ("Allan", "Germaine", "0038", "936627", "boy"),
     ("Hipolito", "Churchill", "0032", "115468", "boy"),
     ("Danita", "Tseng", "0032", "904728", "girl"),
     ("Shelia", "Musson", "0083", "367289", "girl"),
     ("Arnold", "Nail", "0033", "647830", "boy"),
     ("Kimiko", "Patin", "0052", "543794", "girl"),
     ("Hattie", "Steffes", "0078", "647730", "girl"),
     ("Evia", "Harkleroad", "0078", "894003", "girl"),
     ("Murray", "Marasco", "0078", "667468", "boy"),
     ("Albertina", "Landy", "0065", "478204", "girl"),
     ("Efren", "Earle", "0089", "647390", "boy") ]
        .map { (firstName, lastName, countryCode, numberString, avatar) -> Contact in

      let contact = Contact(firstName: firstName, lastName: lastName, avatar: avatar)
      let number = Number(countryCode: countryCode, numberString: numberString, contact: contact)

      contact.number = number
      return contact
    }

  private init() {}
}
