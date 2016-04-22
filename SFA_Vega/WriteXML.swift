//
//  WriteXML.swift
//  Vega3
//
//  Created by Владимир Невинный on 09.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit
//import Photos

class WriteXML: NSObject {
    
    private let dateFormattter = NSDateFormatter()
    
    private var orderes: [NVPOrder]?
    private var inventores: [NVPInventory]?
    private var salesForBonus: [NVPSalesForBonus]?

    override init() {
        dateFormattter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        super.init()
    }
    
    convenience init(url: String, user: String, password: String) {
        self.init()
        
        var text = "<Root>\r\n"
        
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
            text += self.getInventory()
            text += self.getOrder()
            text += self.getSalesForBonus()
        //})
        
    //    let sweetFTP = NVPSweetFTP(link: url, user: user, password: password)
        
        text  += "</Root>"
        
        let link = "ftp://"+user+":"+password+"@"+url+"/"
        
        let urlFTP = link+"docs.xml"
        
        
        if writeFTP(urlFTP, text: text) == true {
            if let orderes = orderes {
                
                for order in orderes {
                    order.sent = true
                }
            }
            
            if let inventores = inventores {
                
                for inventory in inventores {
                    inventory.sent = true
                }
            }
            
            if let salesForBonus = salesForBonus {
                
                for salesDoc in salesForBonus {
                    salesDoc.sent = true
                }
            }
        }
        
        
        //Send fotos to FTP 
        if let inventores = inventores {
            for inventory in inventores {
                _ = WriteFTP(url: url, user: user, password: password, inventory: inventory)  
            }
        }
    }
    
    
    
    func getDateForXML(date: NSDate) -> String {
        var strRes = dateFormattter.stringFromDate(date)
        
        let startIndex = strRes.startIndex.advancedBy(10)
        
        strRes.replaceRange(Range(start: startIndex, end: startIndex.advancedBy(1)), with: "T")
        
        
        return strRes
        
        
    }
    
    func getInventory() -> String {
        var text  = ""
        
        inventores = NVPInventory.getInventoresForSent()
        
        if let inventores = inventores {
            
            
            for inventory in inventores {
                
                inventory.sent = true
                
                text  += "<DocumentObject.ИнвентаризацияТорговойТочки>\r\n"
                text  +=  "<Ref>"+inventory.id+"</Ref>\r\n"
                text  +=  "<DeletionMark>false</DeletionMark>\r\n"
                text  +=  "<Date>"+getDateForXML(inventory.date)+"</Date>\r\n"
                text  +=  "<Number></Number>\r\n"
                text  +=  "<Posted>false</Posted>\r\n"
                text  +=  "<Организация>da185b45-bed3-11e1-93dd-f46d046668a1</Организация>\r\n"
                
                text  +=  "<РТП>"+inventory.story.idRTP+"</РТП>\r\n"
                text  +=  "<ТорговаяТочка>" + inventory.story.id + "</ТорговаяТочка>\r\n"
                text  +=  "<Широта>\(inventory.latitude.doubleValue)</Широта>\r\n"
                text  +=  "<Долгота>\(inventory.longitude.doubleValue )</Долгота>\r\n"
                
                
                text  +=  "<Комментарий>test comment</Комментарий>\r\n"
                
                text  +=  "<Ответственный>00000000-0000-0000-0000-000000000000</Ответственный>\r\n"
                
                
                text  +=  "<Товары>\r\n"
                
                for row in inventory.section!.allObjects as! [NVPSectionInvet] {
                    text  +=  "<Row>\r\n"
                    text  +=  "<Номенклатура>"+row.idProduct+"</Номенклатура>\r\n"
                    text  +=  "<КвоПриход>\(row.factResidue.doubleValue)</КвоПриход>\r\n"
                    text  +=  "<КвоРасход>0</КвоРасход>\r\n"
                    text  +=  "</Row>\r\n"
                }
                text  +=  "</Товары>\r\n </DocumentObject.ИнвентаризацияТорговойТочки>\r\n"
                
                
            }
        }
        
        return  text
    }
    
    func getOrder() -> String {
        var text = ""
        
        
        orderes = NVPOrder.getOrdersForSent()
        
        if let orderes = orderes {
            
            for order in orderes {
                
                if order.section!.count == 0 {
                    continue
                }
                
                text  +=  "<DocumentObject.ЗаказПокупателя>\r\n"
                text  +=  "<Ref>"+order.id+"</Ref>\r\n"
                text  +=  "<DeletionMark>false</DeletionMark>\r\n"
               
                
                text  +=  "<Date>"+getDateForXML(order.date)+"</Date>\r\n"
                text  +=  "<Number></Number>\r\n"
                text  +=  "<Posted>false</Posted>\r\n"
                text  +=  "<АдресДоставки/>\r\n"
                text  +=  "<ВалютаДокумента>bf988845-3437-11dc-9232-003048327050</ВалютаДокумента>\r\n"
                text  +=  "<УдалитьВремяНапоминания>0001-01-01T00:00:00</УдалитьВремяНапоминания>\r\n"
                text  +=  "<ДатаОплаты>0001-01-01T00:00:00</ДатаОплаты>\r\n"
                text  +=  "<ДатаОтгрузки>"+getDateForXML(order.date)+"</ДатаОтгрузки>\r\n"
                text  +=  "<ДисконтнаяКарта>00000000-0000-0000-0000-000000000000</ДисконтнаяКарта>\r\n"
                text  +=  "<ДоговорКонтрагента>00000000-0000-0000-0000-000000000000</ДоговорКонтрагента>\r\n"
                text  +=  "<ИспользоватьПлановуюСебестоимость>false</ИспользоватьПлановуюСебестоимость>\r\n"
                text  +=  "<ИтогПлановаяСебестоимость>0</ИтогПлановаяСебестоимость>\r\n"
                text  +=  "<Комментарий>"+order.comment+"</Комментарий>\r\n"
                text  +=  "<Контрагент>"+order.store.client!.id+"</Контрагент>\r\n"
                text  +=  "<КратностьВзаиморасчетов>1</КратностьВзаиморасчетов>\r\n"
                text  +=  "<КурсВзаиморасчетов>1</КурсВзаиморасчетов>\r\n"
                text  +=  "<УдалитьНапомнитьОСобытии>false</УдалитьНапомнитьОСобытии>\r\n"
                text  +=  "<Организация>da185b45-bed3-11e1-93dd-f46d046668a1</Организация>\r\n"
                text  +=  "<Ответственный>00000000-0000-0000-0000-000000000000</Ответственный>\r\n"
                text  +=  "<Подразделение>00000000-0000-0000-0000-000000000000</Подразделение>\r\n"
                text  +=  "<СтруктурнаяЕдиница xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/>\r\n"//25
                
                
                
                text  +=  "<СкладГруппа xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"CatalogRef.Склады\">00000000-0000-0000-0000-000000000000</СкладГруппа>\r\n"
                
                
                var f2 = "true"
                
                
                if order.payForma2 == true {
                    f2 = "false"
                }
                
                
                
                text  +=  "<СуммаВключаетНДС>"+f2+"</СуммаВключаетНДС>\r\n"
                
                
                text  +=  "<СуммаДокумента>0</СуммаДокумента>\r\n"
                text  +=  "<ТипЦен>00000000-0000-0000-0000-000000000000</ТипЦен>\r\n"
                text  +=  "<УдалитьКонтактноеЛицо>00000000-0000-0000-0000-000000000000</УдалитьКонтактноеЛицо>\r\n" //30
                
                text  +=  "<УчитыватьНДС>"+f2+"</УчитыватьНДС>\r\n"
                text  +=  "<АвторасчетНДС>"+f2+"</АвторасчетНДС>\r\n"
                
                
                text  +=  "<Грузополучатель>00000000-0000-0000-0000-000000000000</Грузополучатель>\r\n"
                text  +=  "<КонтактноеЛицоКонтрагента>00000000-0000-0000-0000-000000000000</КонтактноеЛицоКонтрагента>\r\n"
                text  +=  "<УсловиеПродаж>00000000-0000-0000-0000-000000000000</УсловиеПродаж>\r\n"
                text  +=  "<ДополнениеКАдресуДоставки/>\r\n"
                text  +=  "<ДокументОснование xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/>\r\n"
                text  +=  "<Грузоотправитель>00000000-0000-0000-0000-000000000000</Грузоотправитель>\r\n"
                text  +=  "<НомерВходящегоДокументаЭлектронногоОбмена/>\r\n"
                text  +=  "<ДатаВходящегоДокументаЭлектронногоОбмена>0001-01-01T00:00:00</ДатаВходящегоДокументаЭлектронногоОбмена>\r\n"
                text  +=  "<СуммаБезНДС>0</СуммаБезНДС>\r\n"
                text  +=  "<НДС>0</НДС>\r\n"
                text  +=  "<РТП>"+order.store.idRTP+"</РТП>\r\n"
                text  +=  "<УдалитьТипСкидкиНаценки>00000000-0000-0000-0000-000000000000</УдалитьТипСкидкиНаценки>\r\n"
                text  +=  "<ИмяФайла/>\r\n"
                text  +=  "<АвтоПеремещение>false</АвтоПеремещение>\r\n"
                text  +=  "<АвтоРезервирование>false</АвтоРезервирование>\r\n"
                text  +=  "<АвтоРазмещение>false</АвтоРазмещение>\r\n"
                text  +=  "<EDIINTERCHANGEID/>\r\n"
                text  +=  "<НомерПокупателя/>\r\n"
                text  +=  "<ТорговаяТочка>"+order.store.id+"</ТорговаяТочка>\n"
                text  +=  "<Менеджер>00000000-0000-0000-0000-000000000000</Менеджер>\r\n"
                text  +=  "<ДокОснования>"+order.idInventory+"</ДокОснования>"
                text  +=  "<Товары>\r\n"
                
                
                for row in order.section!.allObjects as! [NVPSectionOrder] {
                    if row.quantity == 0 {
                        continue
                    }
                    
                    text  +=  "<Row>\r\n"
                    
                    
                    var idEd = "00000000-0000-0000-0000-000000000000" //27
                    
                    var price: Double = 0
                    var nds = "БезНДС"
                    
                    
                    if let product = NVPProduct.getProduct(id:row.idProduct) {
                        idEd = product.idEd
                        
                        nds = product.nds
                        
                        if product.contractPrice == true {
                            price = row.price.doubleValue
                        }
                    }
                    text  +=  "<ЕдиницаИзмерения>"+idEd+"</ЕдиницаИзмерения>\r\n"
                    text  +=  "<ЕдиницаИзмеренияМест>00000000-0000-0000-0000-000000000000</ЕдиницаИзмеренияМест>\r\n"
                    text  +=  "<Количество>\(row.quantity.doubleValue)</Количество>\r\n" //62
                    text  +=  "<КоличествоМест>0</КоличествоМест>\r\n"
                    text  +=  "<Коэффициент>1</Коэффициент>\r\n"
                    text  +=  "<Номенклатура>"+row.idProduct+"</Номенклатура>\r\n"
                    text  +=  "<ПлановаяСебестоимость>0</ПлановаяСебестоимость>\r\n"
                    text  +=  "<ПроцентСкидкиНаценки>0</ПроцентСкидкиНаценки>\r\n"
                    text  +=  "<Размещение xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/>\r\n"
                    text  +=  "<СтавкаНДС>"+nds+"</СтавкаНДС>\r\n"
                    text  +=  "<Сумма>0</Сумма>\r\n"
                    text  +=  "<СуммаНДС>0</СуммаНДС>\r\n"
                    text  +=  "<ХарактеристикаНоменклатуры>00000000-0000-0000-0000-000000000000</ХарактеристикаНоменклатуры>\r\n"
                    
                    text  +=  "<Цена>\(price)</Цена>\r\n"
                    
                    
                    text  +=  "<ПроцентАвтоматическихСкидок>0</ПроцентАвтоматическихСкидок>\r\n"
                    text  +=  "<УсловиеАвтоматическойСкидки/>\r\n"
                    text  +=  "<ЗначениеУсловияАвтоматическойСкидки xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/>\r\n"
                    text  +=  "<КлючСтроки>1</КлючСтроки>\n"
                    text  +=  "<СерияНоменклатуры>00000000-0000-0000-0000-000000000000</СерияНоменклатуры>\r\n"
                    text  +=  "<Качество>00000000-0000-0000-0000-000000000000</Качество>\r\n"
                    text  +=  "<ТипЦен>00000000-0000-0000-0000-000000000000</ТипЦен>\r\n"
                    text  +=  "</Row>\r\n"
                    
                }
                text  +=  "</Товары>\r\n"
                text  +=  "<ВозвратнаяТара/>\r\n"
                text  +=  "<Услуги/>\r\n"
                text  +=  "<СоставНабора/>\r\n"
                text  +=  "</DocumentObject.ЗаказПокупателя>\r\n"
            }
        }

        
        return text
    }
    
    
    func getSalesForBonus() -> String {
        var text = ""
        
        
        salesForBonus = NVPSalesForBonus.getSalesForBonusForSent()
        
        if let salesForBonus = salesForBonus {
            
            for saleDocum in salesForBonus {
                
                if saleDocum.section!.count == 0 {
                    continue
                }
    
                text  +=  "<DocumentObject.ПродажиПодБонусы>\r\n"
                text  +=  "<Ref>"+saleDocum.id+"</Ref>\r\n"
                text  +=  "<DeletionMark>false</DeletionMark>\r\n"
                text  +=  "<Date>"+getDateForXML(saleDocum.date)+"</Date>\r\n"
                text  +=  "<Number></Number>"
                text  +=  "<Posted>false</Posted>\r\n"
                text  +=  "<ТорговаяТочка>"+saleDocum.store.id+"</ТорговаяТочка>\r\n"
                text  +=  "<Контрагент>"+saleDocum.store.client!.id+"</Контрагент>\r\n"
                text  +=  "<ТорговыйМенеджер>00000000-0000-0000-0000-000000000000</ТорговыйМенеджер>\r\n"
                text  +=  "<РТП>"+saleDocum.store.idRTP+"</РТП>"
                text  +=  "<МобильныеУстройства>00000000-0000-0000-0000-000000000000</МобильныеУстройства>\r\n"
                text  +=  "<Продажи>\r\n"
                
                for row in saleDocum.section!.allObjects as! [NVPSectionSalesForBonus] {
                    if row.quantity == 0 {
                        continue
                    }
                    
                    text  +=  "<Row>\r\n"
                    text  +=  "<Номенклатура>"+row.idProduct+"</Номенклатура>\r\n"
                    text  +=  "<Количество>\(row.quantity.doubleValue)</Количество>\r\n"
                    text  +=  "</Row>\r\n"
                }
                text  +=  "</Продажи>\r\n"
                text  +=  "</DocumentObject.ПродажиПодБонусы>\r\n"
                
               
                
            }
        }
        
         return text
    }
    
    
    func writeFTP(urlFTP: String, text: String) -> Bool {
        
        let ftpstring = CFURLCreateWithString(nil, urlFTP, nil)
        
        
        
        let stream = CFWriteStreamCreateWithFTPURL(nil, ftpstring)
        
        //let stream = NSURLSessionA
        
        let streamWrite: CFWriteStream = stream.takeUnretainedValue()
            
            
           // var status: Bool
            
            let cfstatus: Bool = CFWriteStreamOpen(streamWrite)
            
            if cfstatus == true {
                if let _buffer = text.cStringUsingEncoding(NSUTF8StringEncoding) {
                    
                    var buffer:[UInt8]  =  [UInt8]()
                    
                    buffer.append(0xef)
                    buffer.append(0xbb)
                    buffer.append(0xbf)
                    
                    for value in _buffer {
                        
                        buffer.append(UInt8(bitPattern: value))
                    }
                    
                    buffer[buffer.count-1] = (0x20)
                    
                  //  var offset = 0
                    
                    
                    var currentIndex = 0
                    
                    var index = 0
                    
                    let buf = UnsafePointer<UInt8>(buffer)
                    
                    
                    while currentIndex < buffer.count {
                        
                            
                        index = CFWriteStreamWrite(streamWrite, buf+currentIndex,  buffer.count-currentIndex)
                        
                        if index == -1 {
                            CFWriteStreamClose(streamWrite)
                            
                            return false
                        }
                        
                        if index > 0 {
                            currentIndex += index
                        }
                    }
                }
                
                CFWriteStreamClose(streamWrite)
                
                
                return true
            
        }
        
        return false
    }

}
