#Область ПрограммныйИнтерфейс

Функция ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов) Экспорт

	ЗначенияРеквизитов = Новый Структура(ИменаРеквизитов);
	
	ТекстЗапроса = "ВЫБРАТЬ Таб.Ссылка КАК Ссылка";
	
	Для Каждого ОписаниеРеквизита Из ЗначенияРеквизитов Цикл
		ТекстЗапроса = ТекстЗапроса + ", Таб." + ОписаниеРеквизита.Ключ + " КАК " + ОписаниеРеквизита.Ключ;
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + " ИЗ " + Ссылка.Метаданные().ПолноеИмя() + " КАК Таб ГДЕ Таб.Ссылка =  &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Рез = Запрос.Выполнить();
	
	Если Рез.Пустой() Тогда
		Возврат ЗначенияРеквизитов;
	КонецЕсли;
		
	Выборка = Рез.Выбрать();
	Выборка.Следующий();
	
	Для Каждого КлючЗначение Из ЗначенияРеквизитов Цикл
		ЗначенияРеквизитов.Вставить(КлючЗначение.Ключ, Выборка[КлючЗначение.Ключ]); 	
	КонецЦикла;
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции

#КонецОбласти
