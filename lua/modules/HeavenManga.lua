-- Get info and chapter list for current manga.
function GetInfo()
	local pages, x, v = nil
	local u = MaybeFillHost(MODULE.RootURL, URL):gsub('/+$', '') .. '/'
	local p = 1

	if not HTTP.GET(u) then return net_problem end

	x = CreateTXQuery(HTTP.Document)
	MANGAINFO.CoverLink = MaybeFillHost(MODULE.RootURL, x.XPathString('//div[@class="comic-info"]/div/img/@src'))
	MANGAINFO.Title     = x.XPathString('//div[@class="info"]/h1')
	MANGAINFO.Authors   = x.XPathStringAll('//div[@class="info"]//div[@class="author"]/a')
	MANGAINFO.Genres    = x.XPathStringAll('//div[@class="info"]//div[@class="genre"]/a')
	MANGAINFO.Status    = MangaInfoStatusIfPos(x.XPathString('//div[@class="info"]//div[@class="update"]/span[last()]'))
	MANGAINFO.Summary   = x.XPathString('//div[@class="comic-description"]/p')

	pages = tonumber(x.XPathString('//div[@class="pagination"]//a[contains(@class, "page-numbers")][last()]/substring-after(@href, "/page-")'))
	if pages == nil then pages = 1 end
	while true do
		for v in x.XPath('//div[contains(@class, "chapters-wrapper")]//h2[@class="chap"]/a').Get() do
			if x.XPathString('span/text()', v) == 'RAW' then 
				if MODULE.GetOption('luaincluderaw') then
				MANGAINFO.ChapterNames.Add(x.XPathString('text()', v) .. ' ' .. x.XPathString('span/text()', v))
				MANGAINFO.ChapterLinks.Add(v.GetAttribute('href'))
				end
			else
				MANGAINFO.ChapterNames.Add(x.XPathString('text()', v))
				MANGAINFO.ChapterLinks.Add(v.GetAttribute('href'))
			end
		end
		p = p + 1
		if p > pages then
			break
		elseif HTTP.GET(u .. '/page-' .. tostring(p)) then
			x = CreateTXQuery(HTTP.Document)
		else
			break
		end
	end
	MANGAINFO.ChapterLinks.Reverse(); MANGAINFO.ChapterNames.Reverse()

	return no_error
end

-- Get the page count for the current chapter.
function GetPageNumber()
	local v, x = nil
	local u = MaybeFillHost(MODULE.RootURL, URL):gsub('/+$', '') .. '/'

	if not HTTP.GET(u) then return net_problem end

	x = CreateTXQuery(HTTP.Document)
	for v in x.XPath('//div[@class="chapter-content"]//img').Get() do
		local src = v.GetAttribute('src')
		if src:find('&url=') then
			src = string.match(src, "&url=(.*)")
		end
    TASK.PageLinks.Add(src)
	end

	return no_error
end

-- Get the page count of the manga list of the current website.
function GetDirectoryPageNumber()
	local x = nil
	local u = MODULE.RootURL .. '/manga-list/page-1/'

	if not HTTP.GET(u) then return net_problem end

	PAGENUMBER = tonumber(CreateTXQuery(HTTP.Document).XPathString('(//div[@class="pagination"]/a[contains(@class, "page-numbers")])[last()]/substring-after(@href, "/page-")'))

	return no_error
end

-- Get LINKS and NAMES from the manga list of the current website.
function GetNameAndLink()
	local x = nil
	local u = MODULE.RootURL .. '/manga-list/page-' .. (URL + 1) .. '/'

	if not HTTP.GET(u) then return net_problem end

	x = CreateTXQuery(HTTP.Document)
	x.XPathHREFAll('//div[@class="comics-grid"]/div/div/h3/a', LINKS, NAMES)

	return no_error
end

function BeforeDownloadImage()
	HTTP.Headers.Values['Referer'] = ' ' .. MaybeFillHost(MODULE.RootURL, TASK.ChapterLinks[TASK.CurrentDownloadChapterPtr])
	return true
end

----------------------------------------------------------------------------------------------------
-- Module Initialization
----------------------------------------------------------------------------------------------------

function Init()
	function AddWebsiteModule(id, name, url)
		local m = NewWebsiteModule()
		m.ID                          = id
		m.Name                        = name
		m.RootURL                     = url
		m.Category                    = 'English'
		m.OnGetInfo                   = 'GetInfo'
		m.OnGetNameAndLink            = 'GetNameAndLink'
		m.OnGetPageNumber             = 'GetPageNumber'
		m.OnGetDirectoryPageNumber    = 'GetDirectoryPageNumber'
		m.OnBeforeDownloadImage       = 'BeforeDownloadImage'

		local fmd = require 'fmd.env'
		local slang = fmd.SelectedLanguage
		local lang = {
			['en'] = {
				['includeraw'] = 'Show [RAW] chapters'
			},
			['id_ID'] = {
				['includeraw'] = 'Tampilkan bab [RAW]'
			},
			get =
				function(self, key)
					local sel = self[slang]
					if sel == nil then sel = self['en'] end
					return sel[key]
				end
		}
		m.AddOptionCheckBox('luaincluderaw', lang:get('includeraw'), false)
	end
	AddWebsiteModule('3b0d5c38081a4b21a39a388a3ec59197', 'HeavenToon', 'https://ww4.heaventoon.com')
	AddWebsiteModule('a9a8bd394d63495686794a8d427bda00', 'HolyManga', 'https://ww1.holymanga.net')
	AddWebsiteModule('f49e608b66994721a5ea992b56367d96', 'KooManga', 'https://ww6.koomanga.com')
end
