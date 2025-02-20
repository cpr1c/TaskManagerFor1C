
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ЗаполнитьПараметрыЗадания();

		Ключ = Запись.Ключ;
		КлючИсполнителя = Запись.КлючИсполнителя;
	КонецЕсли;

	ТолькоПросмотр = Истина;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыЗадания()
	Попытка
		ОбъектЗапись = РеквизитФормыВЗначение("Запись");
		Содержание = ОбъектЗапись.Параметры.Получить();
		Если ТипЗнч(Содержание) = Тип("Структура") Тогда
			ОбъектXDTO = СериализаторXDTO.ЗаписатьXDTO(Содержание);
			
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.УстановитьСтроку("UTF-8");
			ЗаписьXML.ЗаписатьОбъявлениеXML();
			ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO);
			XML = ЗаписьXML.Закрыть();
			
			ТекстПреобразованияXSL = РегистрыСведений.мзЗадания.ПолучитьМакет("defaultss_xml");
			Преобразование = Новый ПреобразованиеXSL;
			Преобразование.ЗагрузитьИзСтроки(ТекстПреобразованияXSL.ПолучитьТекст());
			ПараметрыЗаданияXML = Преобразование.ПреобразоватьИзСтроки(XML);

			ПараметрыЗаданияСтрока = ЗначениеВСтрокуВнутр(Содержание);
		КонецЕсли;	
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Сообщить("Не удалось получить содержание сообщения: " + ОписаниеОшибки);
	КонецПопытки;
КонецПроцедуры

