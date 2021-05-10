
#Область МенеджерЗаданий
// { Менеджер заданий
Функция ЗапуститьМенеджераЗаданий() Экспорт
	ОстановитьМенеджераЗаданий();
	
	РегламентноеЗадание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.мзМенеджерЗаданий);
	РегламентноеЗадание.Записать();
	
	Возврат РегламентноеЗадание.УникальныйИдентификатор;
КонецФункции

Процедура МенеджерЗаданий_Выполнение() Экспорт
	АктивныеИсполнители = ПолучитьАктивныхИсполнителей();
	ОсвободитьЗаданияБезАктивныхИсполнителей(АктивныеИсполнители);
	ОтменитьЗаданияСДостигнутымЛимитомПоМаксимальномуКоличествуПопытокВыполнения();
	СнятьЗаданияСПаузы();
	ЗапуститьНовыхИсполнителей(АктивныеИсполнители);
	СократитьИсториюВыполненияЗаданийДоГлубиныХраненияИзНастроек();
КонецПроцедуры

Процедура ЗапуститьНовыхИсполнителей(Знач АктивныеИсполнители)
	КоличесвоЗаданийВОчереди = ПолучитьКоличесвоЗаданийВОчереди();
	ОграничениеПоКоличествуИсполнителей = ПолучитьОграничениеНаКоличествоИсполнителей();
	КоличествоДобавляемыхИсполнителей = Мин(ОграничениеПоКоличествуИсполнителей - АктивныеИсполнители.Количество(), КоличесвоЗаданийВОчереди);
	Если КоличествоДобавляемыхИсполнителей > 0 Тогда
		Задания = ПолучитьЗаданияИзОчереди(КоличествоДобавляемыхИсполнителей);
		Для каждого КлючЗадания Из Задания Цикл
			КлючИдентификацииИсполнителя = СгенерироватьКлючИдентификацииИсполнителя();
			ЗапуститьИсполнителя(КлючИдентификацииИсполнителя, КлючЗадания);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура СократитьИсториюВыполненияЗаданийДоГлубиныХраненияИзНастроек()
	ГлубинаХраненияИстории = ПолучитьГлубинуХраненияИстории();
	ПредопределенныеЗначенияГлубиныХраненияИстории = мзЗадания.ПолучитьПредопределенныеЗначенияГлубиныХраненияИстории();
	Если ГлубинаХраненияИстории <> ПредопределенныеЗначенияГлубиныХраненияИстории.Бесконечная Тогда
		СократитьИсториюВыполненияЗаданий(ГлубинаХраненияИстории);
	КонецЕсли;
КонецПроцедуры

Процедура ОстановитьМенеджераЗаданий() Экспорт
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.мзМенеджерЗаданий);
	АктивныеРегламентныеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Для каждого РегЗадание Из АктивныеРегламентныеЗадания Цикл
		РегЗадание.Удалить();
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьОграничениеНаКоличествоИсполнителей() Экспорт
	ОграничениеНаКоличествоИсполнителей = Константы.мзОграничениеНаКоличествоИсполнителей.Получить();
	
	Возврат ОграничениеНаКоличествоИсполнителей;
КонецФункции

Процедура УстановитьОграничениеПоКоличествуИсполнителей(Знач ОграничениеНаКоличествоИсполнителей) Экспорт
	Константы.мзОграничениеНаКоличествоИсполнителей.Установить(ОграничениеНаКоличествоИсполнителей);
КонецПроцедуры

Функция ПолучитьГлубинуХраненияИстории() Экспорт
	ГлубинаХраненияИстории = Константы.мзГлубинаХраненияИстории.Получить();
	
	Возврат ГлубинаХраненияИстории;
КонецФункции

Процедура УстановитьГлубинуХраненияИстории(Знач ГлубинаХраненияИстории) Экспорт
	Константы.мзГлубинаХраненияИстории.Установить(ГлубинаХраненияИстории);
КонецПроцедуры
// } Менеджер заданий
#КонецОбласти

#Область ИсполнительЗаданий
// { Исполнитель заданий
Функция ЗапуститьИсполнителя(Знач КлючИдентификацииИсполнителя, Знач КлючЗадания) Экспорт
	Параметры = Новый Массив;
	Параметры.Добавить(КлючИдентификацииИсполнителя);
	Параметры.Добавить(КлючЗадания);
	Фоновое = ФоновыеЗадания.Выполнить("мзЗадания.Исполнитель_Выполнение", Параметры, КлючИдентификацииИсполнителя);
	Возврат Фоновое;
КонецФункции

Процедура Исполнитель_Выполнение(Знач КлючИдентификацииИсполнителя, Знач КлючЗадания) Экспорт
	КлючИсполнителя = ИдентифицироватьИсполнителя(КлючИдентификацииИсполнителя);
	ДеталиЗадания = ВзятьЗаданиеВРаботу(КлючЗадания, КлючИсполнителя);
	Если ЗначениеЗаполнено(ДеталиЗадания) Тогда
		Если ДеталиЗадания.ВидМетода = ПредопределенноеЗначение("Перечисление.мзВидыМетодов.ВызовМетода") Тогда
			Если ЗначениеЗаполнено(ДеталиЗадания.Алгоритм) Тогда
				Выполнить(ДеталиЗадания.Алгоритм + "(ДеталиЗадания.Параметры)");
			КонецЕсли;
		ИначеЕсли ДеталиЗадания.ВидМетода = ПредопределенноеЗначение("Перечисление.мзВидыМетодов.ПроизвольныйАлгоритм") Тогда
			Если ЗначениеЗаполнено(ДеталиЗадания.Алгоритм) Тогда
				//@skip-warning
				Параметры = ДеталиЗадания.Параметры;
				Выполнить(ДеталиЗадания.Алгоритм);
			КонецЕсли;			
		Иначе
			ВызватьИсключение "Пока реализовано выполнение только методов с видами ""Вызов метода"" и ""Произвольный алгоритм""";
		КонецЕсли;
		ОтметитьЗавершениеЗадания(КлючЗадания);
	КонецЕсли;
КонецПроцедуры

Функция ИдентифицироватьИсполнителя(Знач КлючИдентификацииИсполнителя)
	Отбор = Новый Структура("Ключ", КлючИдентификацииИсполнителя);
	МассивФоновых = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	ТекущееФоновое = МассивФоновых[0];
	КлючИсполнителя = ТекущееФоновое.УникальныйИдентификатор;
	
	Возврат КлючИсполнителя;
КонецФункции

Функция ПолучитьАктивныхИсполнителей() Экспорт
	Отбор = Новый Структура("Метод", "мзЗадания.Исполнитель_Выполнение");
	ВсеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	АктивныеИсполнители = Новый Массив;
	Для каждого Фоновое Из ВсеФоновыеЗадания Цикл
		Если Фоновое.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			АктивныеИсполнители.Добавить(Фоновое);
		КонецЕсли;
	КонецЦикла;
	
	Возврат АктивныеИсполнители;
КонецФункции

Функция ПолучитьКоличествоАктивныхИсполнителей() Экспорт
	Возврат ПолучитьАктивныхИсполнителей().Количество();
КонецФункции

Процедура ОстановитьАктивныхИсполнителей() Экспорт
	АктивныеИсполнители = ПолучитьАктивныхИсполнителей();
	Для каждого АктивныйИсполнитель из АктивныеИсполнители цикл
		Если АктивныйИсполнитель.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			 АктивныйИсполнитель.Отменить();
		КонецЕсли;	 
	КонецЦикла;
КонецПроцедуры
// } Исполнитель заданий
#КонецОбласти

#Область РаботаСЗаданием
// { Работа с заданием
Функция ДобавитьЗадание(Знач Метод, Знач Параметры) Экспорт
	Задание = ПодготовитьМенеджераЗаписиЗадания(Метод, Параметры);
	Задание.Состояние = Перечисления.мзСостоянияЗаданий.Ожидает;
	Задание.Записать();
	
	Возврат Задание.Ключ;
КонецФункции

Функция ПодготовитьМенеджераЗаписиЗадания(Знач Метод, Знач Параметры, Знач Период = Неопределено)
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		ВызватьИсключение ПолучитьВозможныеИсключения().ПараметрыЗаданияДолжныБытьСтруктурой;
	КонецЕсли;
	
	КлючЗадания = Новый УникальныйИдентификатор();
	Параметры.Вставить("КлючЗадания", КлючЗадания);
	
	Задание = РегистрыСведений.мзЗадания.СоздатьМенеджерЗаписи();
	Если ЗначениеЗаполнено(Период) Тогда
		Задание.Период = Период;
	Иначе
		Задание.Период = ТекущаяДатаСеанса();
	КонецЕсли;
	Задание.Ключ = КлючЗадания;
	Задание.Метод = Метод;
	Задание.Параметры = Новый ХранилищеЗначения(Параметры, Новый СжатиеДанных(0));
	
	Возврат Задание;
КонецФункции

Функция ДобавитьЗаданиеВнеОчереди(Знач Метод, Знач Параметры) Экспорт
	Задание = ПодготовитьМенеджераЗаписиЗадания(Метод, Параметры);
	Задание.Состояние = Перечисления.мзСостоянияЗаданий.ОжидаетВыделенногоИсполнителя;
	Задание.Записать();
	
	КлючИдентификацииИсполнителя = СгенерироватьКлючИдентификацииИсполнителя();
	ЗапуститьИсполнителя(КлючИдентификацииИсполнителя, Задание.Ключ);
	
	Возврат Задание.Ключ;
КонецФункции

Функция ВзятьЗаданиеВРаботу(Знач КлючЗадания, Знач КлючИсполнителя)
	ДеталиЗадания = Неопределено;
	НаборЗаписей = ПолучитьЗаполненныйНаборЗаписейПоКлючуЗадания(КлючЗадания);
	Если НаборЗаписей.Количество() = 1 Тогда
		Задание = НаборЗаписей[0];
		
		СостоянияДляВзятияВРаботу = ПолучитьСостоянияДляВзятияВРаботу();
		Если СостоянияДляВзятияВРаботу.Найти(Задание.Состояние) <> Неопределено Тогда
			ДеталиЗадания = Новый Структура("Метод, Параметры");
			ДеталиЗадания.Метод = Задание.Метод;
			ДеталиЗадания.Параметры = Задание.Параметры.Получить();
			
			РеквизитыМетода = мзОбщегоНазначения.ЗначенияРеквизитовОбъекта(Задание.Метод, "ВидМетода,Алгоритм");
			ДеталиЗадания.Вставить("ВидМетода", РеквизитыМетода.ВидМетода);
			ДеталиЗадания.Вставить("Алгоритм", РеквизитыМетода.Алгоритм);
				
			Задание.КлючИсполнителя = КлючИсполнителя;
			Задание.Состояние = Перечисления.мзСостоянияЗаданий.Выполняется;
			Задание.НачалоВыполнения = ТекущаяДата();
			Задание.КоличествоПопытокВыполения = Задание.КоличествоПопытокВыполения + 1;
			
			НаборЗаписей.Записать();
			
			СделатьОтметкуВЖР("Начало выполнения задания", КлючЗадания);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДеталиЗадания;
КонецФункции

Процедура ОтметитьЗавершениеЗадания(Знач КлючЗадания)
	НаборЗаписей = ПолучитьЗаполненныйНаборЗаписейПоКлючуЗадания(КлючЗадания);
	Если НаборЗаписей.Количество() = 1 Тогда
		Задание = НаборЗаписей[0];
		Задание.Состояние = Перечисления.мзСостоянияЗаданий.Выполнено;
		Задание.ЗавершениеВыполнения = ТекущаяДата();
		НаборЗаписей.Записать();
		
		СделатьОтметкуВЖР("Завершение выполнения задания", КлючЗадания);
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьСостояниеЗадания(Знач КлючЗадания) Экспорт
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	мзЗадания.Состояние
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|ГДЕ
	|	мзЗадания.Ключ = &КлючЗадания";
	Запрос.УстановитьПараметр("КлючЗадания", КлючЗадания);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Результат = РезультатЗапроса.Выгрузить()[0].Состояние;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ОжидатьСостояниеЗадания(Знач КлючЗадания, Знач ОжидаемоеСостояние, Знач Таймаут = 5) Экспорт
	ВремяВРаботе = 0;
	ДождалисьСостояния = (ОжидаемоеСостояние = ПолучитьСостояниеЗадания(КлючЗадания));
	Пока Не ДождалисьСостояния И (ВремяВРаботе < Таймаут) Цикл
		ВремяВРаботе = ВремяВРаботе + Спать(1);
		ДождалисьСостояния = (ОжидаемоеСостояние = ПолучитьСостояниеЗадания(КлючЗадания));
	КонецЦикла;
	
	Возврат ДождалисьСостояния;
КонецФункции

Функция ОжидатьИзмененияСостояния(Знач КлючЗадания, Знач ТекущееСостояние, Знач Таймаут = 5) Экспорт
	ВремяВРаботе = 0;
	СостояниеИзменилось = (ТекущееСостояние <> ПолучитьСостояниеЗадания(КлючЗадания));
	Пока Не СостояниеИзменилось И (ВремяВРаботе < Таймаут) Цикл
		ВремяВРаботе = ВремяВРаботе + Спать(1);
		СостояниеИзменилось = (ТекущееСостояние <> ПолучитьСостояниеЗадания(КлючЗадания));
	КонецЦикла;
	
	Возврат СостояниеИзменилось;
КонецФункции

Функция ОтменитьЗадание(Знач КлючЗадания) Экспорт
	Успех = Ложь;
	НаборЗаписей = ПолучитьЗаполненныйНаборЗаписейПоКлючуЗадания(КлючЗадания);
	Если НаборЗаписей.Количество() = 1 Тогда
		Задание = НаборЗаписей[0];
		СостоянияПоддерживающиеОтмену = ПолучитьСостоянияПоддерживающиеОтмену();
		Если СостоянияПоддерживающиеОтмену.Найти(Задание.Состояние) <> Неопределено Тогда
			Успех = Истина;
			Задание.Состояние = Перечисления.мзСостоянияЗаданий.Отменено;
			Задание.ЗавершениеВыполнения = ТекущаяДата();
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЕсли;
	
	Возврат Успех;
КонецФункции
// } Работа с заданием
#КонецОбласти

#Область РаботаСМножествамиЗаданий
// { Работа с множествами заданий
Функция ПолучитьСостоянияДляВзятияВРаботу()
	СостоянияДляВзятияВРаботу = Новый Массив;
	СостоянияДляВзятияВРаботу.Добавить(Перечисления.мзСостоянияЗаданий.Ожидает);
	СостоянияДляВзятияВРаботу.Добавить(Перечисления.мзСостоянияЗаданий.ОжидаетВыделенногоИсполнителя);
	
	Возврат СостоянияДляВзятияВРаботу;
КонецФункции

Функция ПолучитьСостоянияПоддерживающиеОтмену()
	СостоянияПоддерживающиеОтмену = ПолучитьСостоянияДляВзятияВРаботу();
	СостоянияПоддерживающиеОтмену.Добавить(Перечисления.мзСостоянияЗаданий.НаПаузе);
	
	Возврат СостоянияПоддерживающиеОтмену;
КонецФункции

Функция ПолучитьКоличествоЗаданийВСостояниях(Знач МассивСостояний)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|ГДЕ
	|	мзЗадания.Состояние В(&Состояния)";
	Запрос.УстановитьПараметр("Состояния", МассивСостояний);
	РезультатЗапроса = Запрос.Выполнить();
	КоличествоЗаданий = РезультатЗапроса.Выгрузить()[0].Количество;
	
	Возврат КоличествоЗаданий;
КонецФункции

Функция ПолучитьКоличествоЗаданийВСостоянии(Знач Состояние)
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Состояние);
	КоличествоЗаданий = ПолучитьКоличествоЗаданийВСостояниях(МассивСостояний);
	
	Возврат КоличествоЗаданий;
КонецФункции

Функция ПолучитьКоличесвоЗаданийВОчереди() Экспорт
	МассивСостояний = ПолучитьСостоянияДляВзятияВРаботу();
	КоличесвоЗаданийВОчереди = ПолучитьКоличествоЗаданийВСостояниях(МассивСостояний);
	
	Возврат КоличесвоЗаданийВОчереди;
КонецФункции

Функция ПолучитьКоличествоЗаданийНаПаузе() Экспорт
	КоличествоЗаданийНаПаузе = ПолучитьКоличествоЗаданийВСостоянии(Перечисления.мзСостоянияЗаданий.НаПаузе);
	
	Возврат КоличествоЗаданийНаПаузе;
КонецФункции

Функция ПолучитьВсеЗаданияВСостояниях(Знач МассивСостояний)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзЗадания.Ключ
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|ГДЕ
	|	мзЗадания.Состояние В (&Состояния)";
	Запрос.УстановитьПараметр("Состояния", МассивСостояний);
	РезультатЗапроса = Запрос.Выполнить();
	ВсеЗаданияВСостояниях = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ключ");
	
	Возврат ВсеЗаданияВСостояниях;
КонецФункции

Функция ПолучитьВсеЗаданияВСостоянии(Знач Состояние)
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Состояние);
	ВсеЗаданияВСостоянии = ПолучитьВсеЗаданияВСостояниях(МассивСостояний);
	
	Возврат ВсеЗаданияВСостоянии;
КонецФункции

Функция ПолучитьВсеЗаданияНаПаузе()
	ВсеЗаданияНаПаузе = ПолучитьВсеЗаданияВСостоянии(Перечисления.мзСостоянияЗаданий.НаПаузе);
	
	Возврат ВсеЗаданияНаПаузе;
КонецФункции

Функция ПолучитьЗаданияИзОчереди(Знач КоличествоЗаданий)
	// Для заданий в состоянии "ОжидаетВыделенногоИсполнителя" делаем допущение, что
	// если за 60 секунд выделенный исполнитель не запустился и не взял задание в работу, то
	// он уже не запустится никогда (например, проблемы с rphost)
	// Обрабатываем такие задания в общем порядке очереди
	
	ИнформацияПоОграничениямНаКоличествоИсполнителей = ПолучитьИнформациюПоОграничениямНаКоличествоИсполнителейМетодовОбработчиков();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзЗадания.Ключ,
	|	мзЗадания.Метод
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.мзНастройкиМетодовОбработчиков КАК мзНастройкиМетодовОбработчиков
	|		ПО мзЗадания.Метод = мзНастройкиМетодовОбработчиков.Метод
	|ГДЕ
	|	(мзЗадания.Состояние = ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.Ожидает)
	|			ИЛИ мзЗадания.Период < &ПериодМинутуНазад
	|				И мзЗадания.Состояние = ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.ОжидаетВыделенногоИсполнителя))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЕСТЬNULL(мзНастройкиМетодовОбработчиков.Приоритет, 0) УБЫВ,
	|	мзЗадания.КоличествоПопытокВыполения,
	|	мзЗадания.Период";
	ОднаМинута = 60;
	Запрос.УстановитьПараметр("ПериодМинутуНазад",  ТекущаяДата() - ОднаМинута);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	ВыбранныеЗадания = Новый Массив;
	Пока Выборка.Следующий() Цикл
		ДеталиПоОграничениям = ИнформацияПоОграничениямНаКоличествоИсполнителей.Получить(Выборка.Метод);
		Если ДеталиПоОграничениям = Неопределено Тогда
			ВыбранныеЗадания.Добавить(Выборка.Ключ);
		ИначеЕсли ДеталиПоОграничениям.МаксимальноеКоличествоИсполнителей > ДеталиПоОграничениям.КоличествоАктивныхЗаданий Тогда
			ВыбранныеЗадания.Добавить(Выборка.Ключ);
			ДеталиПоОграничениям.КоличествоАктивныхЗаданий = ДеталиПоОграничениям.КоличествоАктивныхЗаданий + 1;
		КонецЕсли;
		
		Если ВыбранныеЗадания.Количество() = КоличествоЗаданий Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВыбранныеЗадания;
КонецФункции

Функция ПолучитьИнформациюПоОграничениямНаКоличествоИсполнителейМетодовОбработчиков()
	ИнформацияПоОграничениямНаКоличествоИсполнителей = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзНастройкиМетодовОбработчиков.Метод,
	|	мзНастройкиМетодовОбработчиков.МаксимальноеКоличествоИсполнителей
	|ИЗ
	|	РегистрСведений.мзНастройкиМетодовОбработчиков КАК мзНастройкиМетодовОбработчиков
	|ГДЕ
	|	мзНастройкиМетодовОбработчиков.МаксимальноеКоличествоИсполнителей > 0";
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДеталиПоОграничениям = Новый Структура("МаксимальноеКоличествоИсполнителей, КоличествоАктивныхЗаданий", Выборка.МаксимальноеКоличествоИсполнителей, 0);
		ИнформацияПоОграничениямНаКоличествоИсполнителей.Вставить(Выборка.Метод, ДеталиПоОграничениям);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзЗадания.Метод,
	|	КОЛИЧЕСТВО(*) КАК КоличествоАктивныхЗаданий
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|ГДЕ
	|	мзЗадания.Состояние = ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.Выполняется)
	|
	|СГРУППИРОВАТЬ ПО
	|	мзЗадания.Метод";
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДеталиПоОграничениям = ИнформацияПоОграничениямНаКоличествоИсполнителей.Получить(Выборка.Метод);
		Если ДеталиПоОграничениям <> Неопределено Тогда
			ДеталиПоОграничениям.КоличествоАктивныхЗаданий = Выборка.КоличествоАктивныхЗаданий;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИнформацияПоОграничениямНаКоличествоИсполнителей;
КонецФункции

Процедура ОтменитьВсеЗаданияВОчереди() Экспорт
	СостоянияПоддерживающиеОтмену = ПолучитьСостоянияПоддерживающиеОтмену();
	ЗаданияДляОтмены = ПолучитьВсеЗаданияВСостояниях(СостоянияПоддерживающиеОтмену);
	Для каждого КлючЗадания Из ЗаданияДляОтмены Цикл
		ОтменитьЗадание(КлючЗадания);
	КонецЦикла;
КонецПроцедуры

Процедура ОсвободитьЗаданияБезАктивныхИсполнителей(Знач АктивныеИсполнители)
	МассивУИИсполнителей = Новый Массив();
	Для каждого Исполнитель Из АктивныеИсполнители Цикл
		МассивУИИсполнителей.Добавить(Исполнитель.УникальныйИдентификатор);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзЗадания.Период,
	|	мзЗадания.Ключ,
	|	мзЗадания.Метод,
	|	мзЗадания.Параметры,
	|	мзЗадания.НачалоВыполнения,
	|	мзЗадания.КоличествоПопытокВыполения
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|ГДЕ
	|	мзЗадания.Состояние = ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.Выполняется)
	|	И НЕ мзЗадания.КлючИсполнителя В (&МассивУИИсполнителей)";
	Запрос.УстановитьПараметр("МассивУИИсполнителей", МассивУИИсполнителей);
	
	ПустойУникальныйИдентификатой = ПустойУникальныйИдентификатор();
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Задание = РегистрыСведений.мзЗадания.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Задание, Выборка);
		Задание.КлючИсполнителя = ПустойУникальныйИдентификатой;
		НастройкиМетодаОбработчика = ПолучитьНастройкиМетодаОбработчика(Задание.Метод);
		Если Задание.НачалоВыполнения + НастройкиМетодаОбработчика.ПаузаПередНовойПопыткой > ТекущаяДата() Тогда
			Задание.Состояние = Перечисления.мзСостоянияЗаданий.НаПаузе;
		Иначе
			Задание.Состояние = Перечисления.мзСостоянияЗаданий.Ожидает;
		КонецЕсли;
		Задание.Записать();
	КонецЦикла;
КонецПроцедуры

Функция ДождатьсяВыполнения(Знач КлючиЗаданий, Знач Таймаут = 5) Экспорт
	ВремяВРаботе = 0;
	ДождалисьВыполнения = Ложь;
	Для каждого КлючЗадания Из КлючиЗаданий Цикл
		НачалоОжидания = ТекущаяДата();
		ДождалисьВыполнения = ОжидатьСостояниеЗадания(КлючЗадания, Перечисления.мзСостоянияЗаданий.Выполнено, Таймаут - ВремяВРаботе);
		Если Не ДождалисьВыполнения Тогда
			Прервать;
		КонецЕсли;
		ВремяВРаботе = ВремяВРаботе + (ТекущаяДата() - НачалоОжидания);
	КонецЦикла;
	
	Возврат ДождалисьВыполнения;
КонецФункции

Процедура ОтменитьЗаданияСДостигнутымЛимитомПоМаксимальномуКоличествуПопытокВыполнения()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзЗадания.Ключ
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.мзНастройкиМетодовОбработчиков КАК мзНастройкиМетодовОбработчиков
	|		ПО мзЗадания.Метод = мзНастройкиМетодовОбработчиков.Метод
	|ГДЕ
	|	мзЗадания.Состояние В (ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.Ожидает), ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.НаПаузе))
	|	И мзНастройкиМетодовОбработчиков.МаксимальноеКоличествоПопытокВыполнения > 0
	|	И мзЗадания.КоличествоПопытокВыполения >= мзНастройкиМетодовОбработчиков.МаксимальноеКоличествоПопытокВыполнения";
	РезультатЗапроса = Запрос.Выполнить();
	ЗаданияДляОтмены = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ключ");
	Для каждого КлючЗадания Из ЗаданияДляОтмены Цикл
		ОтменитьЗадание(КлючЗадания);
	КонецЦикла;
КонецПроцедуры

Процедура СнятьЗаданияСПаузы()
	ВсеЗаданияНаПаузе = ПолучитьВсеЗаданияНаПаузе();
	Для каждого КлючЗадания Из ВсеЗаданияНаПаузе Цикл
		НаборЗаписей = ПолучитьЗаполненныйНаборЗаписейПоКлючуЗадания(КлючЗадания);
		Задание = НаборЗаписей[0];
		НастройкиМетодаОбработчика = ПолучитьНастройкиМетодаОбработчика(Задание.Метод);
		Если Задание.НачалоВыполнения + НастройкиМетодаОбработчика.ПаузаПередНовойПопыткой <= ТекущаяДата() Тогда
			Задание.Состояние = Перечисления.мзСостоянияЗаданий.Ожидает;
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
// } Работа с множествами заданий
#КонецОбласти

#Область СостояниеВыполненияЗаданий

Процедура ЗаписатьВЛог(КлючЗадания, Текст, ЭтоОшибка = Ложь, ПроцентВыполнения = 0) Экспорт
	
	ДатаЗаписи = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	НаборЗаписей = РегистрыСведений.мзСостояниеЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ключ.Установить(КлючЗадания);
	НаборЗаписей.Отбор.Дата.Установить(ДатаЗаписи);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Ключ = КлючЗадания;
	Запись.Дата = ДатаЗаписи;
	Запись.Текст = Текст;
	Запись.ЭтоОшибка = ЭтоОшибка;
	Запись.ПроцентВыполнения = ПроцентВыполнения;
	
	НаборЗаписей.Записать();
		
КонецПроцедуры

Функция ЕстьОшибкиВыполнения(КлючЗадания) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	мзСостояниеЗаданий.Дата
	|ИЗ
	|	РегистрСведений.мзСостояниеЗаданий КАК мзСостояниеЗаданий
	|ГДЕ
	|	мзСостояниеЗаданий.Ключ = &Ключ
	|	И мзСостояниеЗаданий.ЭтоОшибка";
	Запрос.УстановитьПараметр("Ключ", КлючЗадания);
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции

Функция ТекстЛога(КлючЗадания, ТолькоОшибки = Ложь) Экспорт
		
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	мзСостояниеЗаданий.Дата КАК ДатаСообщения,
	|	мзСостояниеЗаданий.Текст,
	|	мзСостояниеЗаданий.ЭтоОшибка
	|ИЗ
	|	РегистрСведений.мзСостояниеЗаданий КАК мзСостояниеЗаданий
	|ГДЕ
	|	мзСостояниеЗаданий.Ключ = &Ключ
	|	И &ТекстДополнительныхУсловий
	|УПОРЯДОЧИТЬ ПО
	|	ДатаСообщения";
	
	Если ТолькоОшибки Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстДополнительныхУсловий", "мзСостояниеЗаданий.ЭтоОшибка");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстДополнительныхУсловий", "ИСТИНА");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ключ", КлючЗадания);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Текст.ДобавитьСтроку(Выборка.Текст);	
	КонецЦикла;
	
	Возврат Текст.ПолучитьТекст();
	
КонецФункции

Функция ПроцентВыполненияЗадания(КлючЗадания) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	мзСостояниеЗаданий.ПроцентВыполнения
	|ИЗ
	|	РегистрСведений.мзСостояниеЗаданий КАК мзСостояниеЗаданий
	|ГДЕ
	|	мзСостояниеЗаданий.Ключ = &Ключ
	|	И мзСостояниеЗаданий.ПроцентВыполнения > 0
	|УПОРЯДОЧИТЬ ПО
	|	мзСостояниеЗаданий.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Ключ", КлючЗадания);

	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ПроцентВыполнения;
	
КонецФункции

#КонецОбласти

#Область Служебные
// { Служебные
Функция ПолучитьВозможныеИсключения() Экспорт
	ВозможныеИсключения = Новый Структура();
	ВозможныеИсключения.Вставить("ПараметрыЗаданияДолжныБытьСтруктурой", "Параметры задания должны иметь тип <Структура>");
	ВозможныеИсключения.Вставить("НастройкиМетодаОбработчикаДолжныБытьСтруктурой", "Настройки метода-обработчика должны иметь тип <Структура>");
	
	Возврат Новый ФиксированнаяСтруктура(ВозможныеИсключения);
КонецФункции

Функция ПолучитьПредопределенныеЗначенияГлубиныХраненияИстории() Экспорт
	ПредопределенныеЗначенияГлубиныХраненияИстории = Новый Структура();
	ПредопределенныеЗначенияГлубиныХраненияИстории.Вставить("Бесконечная", 0);
	ПредопределенныеЗначенияГлубиныХраненияИстории.Вставить("День", 1);
	ПредопределенныеЗначенияГлубиныХраненияИстории.Вставить("Неделя", 7);
	ПредопределенныеЗначенияГлубиныХраненияИстории.Вставить("Месяц", 30);
	
	Возврат Новый ФиксированнаяСтруктура(ПредопределенныеЗначенияГлубиныХраненияИстории);
КонецФункции

Функция ПустойУникальныйИдентификатор() Экспорт
	Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
КонецФункции

Функция Спать(Знач Секунды) Экспорт
	Команда = "ping -n " + Формат(Секунды + 1, "ЧДЦ=0; ЧГ=") + " -w 2000 0.0.0.1";
	ЗапуститьПриложение(Команда, , Истина);
	
	Возврат Секунды;
КонецФункции

Функция ПолучитьПрефиксКлючаИсполнителей()
	Возврат "мз_";
КонецФункции

Функция СгенерироватьКлючИдентификацииИсполнителя()
	Возврат ПолучитьПрефиксКлючаИсполнителей() + Строка(Новый УникальныйИдентификатор());
КонецФункции

Функция ПолучитьЗаполненныйНаборЗаписейПоКлючуЗадания(Знач КлючЗадания) Экспорт
	НаборЗаписей = РегистрыСведений.мзЗадания.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ключ.Установить(КлючЗадания);
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей;
КонецФункции

Функция ПолучитьОдинДень() Экспорт
	ОдинДень = 24 * 60 * 60;
	
	Возврат ОдинДень;
КонецФункции

Процедура СократитьИсториюВыполненияЗаданий(Знач ТребуемаяГлубинаИсторииВДнях) Экспорт
	МинимальныйПериодИстории = ТекущаяДата() - ПолучитьОдинДень() * ТребуемаяГлубинаИсторииВДнях;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзЗадания.Ключ
	|ИЗ
	|	РегистрСведений.мзЗадания КАК мзЗадания
	|ГДЕ
	|	мзЗадания.Период < &МинимальныйПериодИстории
	|	И мзЗадания.Состояние В (ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.Выполнено), ЗНАЧЕНИЕ(Перечисление.мзСостоянияЗаданий.Отменено))";
	Запрос.УстановитьПараметр("МинимальныйПериодИстории", МинимальныйПериодИстории);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	НаборЗаписей = РегистрыСведений.мзЗадания.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей.Отбор.Ключ.Установить(Выборка.Ключ);
		НаборЗаписей.Записать();
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьНастройкиМетодаОбработчика(Знач Метод) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	мзНастройкиМетодовОбработчиков.МаксимальноеКоличествоПопытокВыполнения,
	|	мзНастройкиМетодовОбработчиков.ПаузаПередНовойПопыткой,
	|	мзНастройкиМетодовОбработчиков.МаксимальноеКоличествоИсполнителей,
	|	мзНастройкиМетодовОбработчиков.Приоритет
	|ИЗ
	|	РегистрСведений.мзНастройкиМетодовОбработчиков КАК мзНастройкиМетодовОбработчиков
	|ГДЕ
	|	мзНастройкиМетодовОбработчиков.Метод = &Метод";
	Запрос.УстановитьПараметр("Метод", Метод);
	РезультатЗапроса = Запрос.Выполнить();
	Результат = Новый Структура("МаксимальноеКоличествоПопытокВыполнения, ПаузаПередНовойПопыткой, МаксимальноеКоличествоИсполнителей, Приоритет", 0, 0, 0, 0);
	Если Не РезультатЗапроса.Пустой() Тогда
		ЗаполнитьЗначенияСвойств(Результат, РезультатЗапроса.Выгрузить()[0]);
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура СохранитьНастройкиМетодаОбработчика(Знач Метод, Знач НовыеНастройки) Экспорт
	Если ТипЗнч(НовыеНастройки) <> Тип("Структура") Тогда
		ВызватьИсключение ПолучитьВозможныеИсключения().НастройкиМетодаОбработчикаДолжныБытьСтруктурой;
	КонецЕсли;
	МенеджерЗаписи = РегистрыСведений.мзНастройкиМетодовОбработчиков.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Метод = Метод;
	МенеджерЗаписи.Прочитать();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, НовыеНастройки);
	Если Не МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Метод = Метод;
	КонецЕсли;
	МенеджерЗаписи.Записать();
КонецПроцедуры

Процедура СделатьОтметкуВЖР(Знач Событие, Знач КлючЗадания)
	ИмяСобытия = Метаданные.Подсистемы.МенеджерЗаданий.Синоним + "." + Событие;
	Комментарий = "Задание = " + КлючЗадания;
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Примечание, , , Комментарий);
КонецПроцедуры
// } Служебные
#КонецОбласти
