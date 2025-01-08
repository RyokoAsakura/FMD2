----------------------------------------------------------------------------------------------------
-- Module Initialization
----------------------------------------------------------------------------------------------------

function Init()
	local m = NewWebsiteModule()
	m.ID                       = 'abbde9b6468f45939e5603416d73ac47'
	m.Name                     = 'WeebCentral'
	m.RootURL                  = 'https://weebcentral.com'
	m.Category                 = 'English'
	m.OnGetDirectoryPageNumber = 'GetDirectoryPageNumber'
	m.OnGetNameAndLink         = 'GetNameAndLink'
	m.OnGetInfo                = 'GetInfo'
	m.OnGetPageNumber          = 'GetPageNumber'
	m.SortedList               = true
end

----------------------------------------------------------------------------------------------------
-- Local Constants
----------------------------------------------------------------------------------------------------

DirectoryPagination = '/search/data?limit=32&sort=Recently+Added&order=Descending&official=Any&display_mode=Full+Display&offset='
DirectoryPageLimit = 32

----------------------------------------------------------------------------------------------------
-- Event Functions
----------------------------------------------------------------------------------------------------

-- Get the page count of the manga list of the current website.
function GetDirectoryPageNumber()
	local s, x = nil
	local u = MODULE.RootURL .. DirectoryPagination .. 0
	PAGENUMBER = 8500

	if not HTTP.GET(u .. PAGENUMBER) then return net_problem end

	x = CreateTXQuery(HTTP.Document)
	s = x.XPathString('//button/@hx-get')
	while string.len(s) > 0 do
		PAGENUMBER = tonumber(s:match('offset=(%d+)')) or PAGENUMBER + DirectoryPageLimit
		if not HTTP.GET(u .. PAGENUMBER) then return net_problem end
		x = CreateTXQuery(HTTP.Document)
		s = x.XPathString('//button/@hx-get')
	end
	PAGENUMBER = math.ceil(PAGENUMBER / DirectoryPageLimit)

	return no_error
end

-- Get links and names from the manga list of the current website.
function GetNameAndLink()
	local v, x = nil
	local u = MODULE.RootURL .. DirectoryPagination .. (DirectoryPageLimit * tonumber(URL))

	if not HTTP.GET(u) then return net_problem end

	x = CreateTXQuery(HTTP.Document)
	for v in x.XPath('//article/section/a').Get() do
		LINKS.Add(v.GetAttribute('href'))
		NAMES.Add(x.XPathString('article[2]/div[2]/div[2]/div', v))
	end

	return no_error
end

-- Get info and chapter list for the current manga.
function GetInfo()
	local v, x = nil
	local u = MaybeFillHost(MODULE.RootURL, URL)

	if not HTTP.GET(u) then return net_problem end

	x = CreateTXQuery(HTTP.Document)
	MANGAINFO.Title     = x.XPathString('(//h1)[1]')
	MANGAINFO.CoverLink = x.XPathString('//meta[@property="og:image"]/@content')
	MANGAINFO.Authors   = x.XPathStringAll('//li[contains(., "Author")]/span/a')
	MANGAINFO.Genres    = x.XPathStringAll('//li[contains(., "Tags")]/span/a')
	MANGAINFO.Status    = MangaInfoStatusIfPos(x.XPathString('//li[contains(., "Status")]/a'), 'Hiatus|Ongoing', 'Canceled|Complete')
	MANGAINFO.Summary   = x.XPathString('//li[contains(., "Description")]/p')

	u = MANGAINFO.URL:gsub('(.*/series/.*)/.*', '%1') .. '/full-chapter-list'
	if not HTTP.GET(u) then return net_problem end
	x = CreateTXQuery(HTTP.Document)
	for v in x.XPath('//a[not(@aria-label)]').Get() do
		MANGAINFO.ChapterLinks.Add(v.GetAttribute('href'))
		MANGAINFO.ChapterNames.Add(x.XPathString('span[2]/span[1]', v))
	end
	MANGAINFO.ChapterLinks.Reverse(); MANGAINFO.ChapterNames.Reverse()

	return no_error
end

-- Get the page count for the current chapter.
function GetPageNumber()
	local u = MaybeFillHost(MODULE.RootURL, URL) .. '/images?reading_style=long_strip'

	if not HTTP.GET(u) then return net_problem end

	CreateTXQuery(HTTP.Document).XPathStringAll('//img/@src', TASK.PageLinks)

	return no_error
end