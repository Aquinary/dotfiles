local LIP = require 'LIP';
local homeDir = os.getenv('HOME')
local history_file = homeDir .. "/.config/history.ini"


--[[ Метод-разделитель ]]
function split (inputstr, sep)
	if sep == nil then
	        sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	        table.insert(t, str)
	end
	return t
end

--[[ Объединяет две таблицы, так как LIP.save перезаписывает файл ]]--
function merge(t1, t2)
    for k, v in pairs(t2['Runs']) do
      if t1['Runs'][k] == nil then
        t1['Runs'][k] = v
      end
    end  
    return t1
end

--[[ Обноавляет историю запуска ]]--
function history_update(exec)
	local file = io.open(history_file, "r")
	if file == nil then
		file = io.open(history_file, "w")
	end

	-- Считываем количество запусков приложения и ini-данные для работы
	local run_count, ini = history_read(exec)
	run_count = run_count + 1
	
	-- Формируем таблицу
	local data = {
		Runs = {
			[exec] = run_count
		}
	}

	-- Сохраняем данные в файле
	if ini and ini["Runs"] then
		LIP.save(history_file, merge(data, ini))
	else
		LIP.save(history_file, data)
	end
end			

--[[ Считывает историю запуска ]]--
function history_read(exec)
	-- Проверяем, существует ли файл
	local file = io.open(history_file, "r")
	if file == nil then
		return 0
	end

	-- Считываем количество запусков и возвращаем результат с ini-данными
	local ini = LIP.load(history_file)

	if ini and (ini['Runs'] and ini['Runs'][exec]) then
		return ini['Runs'][exec], ini
	end

	return 0, ini 
end		

local apps = {}
--[[ Получает список приложений и вытаскивает из них полезную инфу ]]
function get_xdg_apps()
	
	local path =  "/run/current-system/sw/share/applications/"
	local files = io.popen("ls " .. path) -- Получаем список файлов в каталоге
	 
	if files then
		-- Так как возвращается строка, то с разделяем всю строку на подстроки
		local i = 1
		for key, val in ipairs(split(files:read("*a"), '\n\r')) do 
			-- Парсим .desktop файл
			local ini = LIP.load(path .. val)
			local ini_short = ini['Desktop Entry']
			if ini_short then
				-- Данное условие убирает лишние пункты в меню
				if ini_short['NoDisplay'] == false or not ini_short['NoDisplay'] then
					local icon = ini_short['Icon']
					local exec = val
					local name = ini_short['Name[ru]']
					if name == nil then
						name = ini_short['Name']
					end

					local runs, _ = history_read(exec)
					apps[i] = {name=name, icon=icon, exec=exec, runs=runs}
					i = i + 1
				end
			end
		end

		table.sort(apps, function (a, b)
			return b.runs < a.runs
		end)
	else
		print('Error!')
	end
end


function check_argv()
	if arg[1] then
		for k, v in pairs(apps) do
			-- Парсим таблицу с данными и выводим её в rofi
			if arg[1] == '--parse' then
			    
				if v.exec then
					if v.icon ~= nil then
						print (v.name .. "\0icon\x1f" .. v.icon)
					else
						print (v.name)
					end
				end
			end
			-- Возвращает Exec путь для запуска файла
			if arg[1] == '--exec' then
				if v.name == arg[2] then 
					print (v.exec)
				end
			end

			-- Эмуляция истории drun - чем больше запускается приложение, тем выше оно в списке
			if arg[1] == '--history-update' then
				if v.exec == arg[2] then
					history_update(arg[2])
				end
			end
		end
	end
end



get_xdg_apps()
check_argv()





