void ObjcFormatAnsiDateUsingLocale( sqlite3_context* ctx_, int argc_, sqlite3_value** argv_ )
{
    assert( ctx_ ); // на всякий случай 
    
    @autoreleasepool // гарантируем возврат ObjC ресурсов.
    {
        // тут могли быть ваши проверки корректности argc_, argv_
        const unsigned char* rawFormat_ = sqlite3_value_text( argv_[0] );
        const unsigned char* rawDate_   = sqlite3_value_text( argv_[1] );
        const unsigned char* rawLocaleIdentifier_ = sqlite3_value_text( argv_[2] );

        //эта проверка необходима, дабы избежать  crash при переводе строк в NSString
        if ( NULL == rawFormat_ || NULL == rawDate_ || NULL == rawLocaleIdentifier_ )
        {
            sqlite3_result_error( ctx_, "ObjcFormatAnsiDate - NULL argument passed", 3 );
            return;        
        }
        

        // Оборачиваем параметры в NSString
        NSString* strDate_ = [ [ NSString alloc ] initWithBytesNoCopy: (void*)rawDate_
                                                               length: strlen( (const char*)rawDate_ )
                                                             encoding: NSUTF8StringEncoding
                                                         freeWhenDone: NO ];

        NSString* format_ = [ [ NSString alloc ] initWithBytesNoCopy: (void*)rawFormat_
                                                              length: strlen( (const char*)rawFormat_ )
                                                            encoding: NSUTF8StringEncoding
                                                        freeWhenDone: NO ];

        NSString* localeIdentifier_ = [ [ NSString alloc ] initWithBytesNoCopy: (void*)rawLocaleIdentifier_
                                                            length: strlen( (const char*)rawLocaleIdentifier_ )
                                                          encoding: NSUTF8StringEncoding
                                                      freeWhenDone: NO ];


       
        // для входных данных. Имеет локаль en_US_POSIX и формат даты yyyy-MM-dd
        NSDateFormatter* ansiFormatter_ = [ ESLocaleFactory ansiDateFormatter ];
       
       
        // Для форматирования результата. Имеет локаль и формат, переданный извне
        NSLocale* locale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: localeIdentifier_ ];
        NSDateFormatter* targetFormatter_ = [ ESLocaleFactory gregorianDateFormatterWithLocale: locale_ ];
        targetFormatter_.dateFormat = format_;
       
        // собственно, преобразование дат
        NSDate* date_ = [ ansiFormatter_ dateFromString: strDate_ ];
        NSString* result_ = [ targetFormatter_ stringFromDate: date_ ];

       
       
        // возврат результата
        if ( nil == result_ || [ result_ isEqualToString: @"" ] )
        {    
            sqlite3_result_null( ctx_ );
        }
        else 
        {
            sqlite3_result_text
            ( 
                ctx_, 
                (const char*)[ result_ cStringUsingEncoding      : NSUTF8StringEncoding ], 
                (int        )[ result_ lengthOfBytesUsingEncoding: NSUTF8StringEncoding ], 
                SQLITE_TRANSIENT  // просим SQLite сделать копию строки-результата
            );
        }
    }
}