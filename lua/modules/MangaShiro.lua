function GetInfo()
	MANGAINFO.URL = MaybeFillHost(MODULE.RootURL, URL)
	if HTTP.GET(MANGAINFO.URL) then
		local x = CreateTXQuery(HTTP.Document)
		MANGAINFO.Title     = getTitle(x)
		MANGAINFO.CoverLink = MaybeFillHost(MODULE.RootURL, getCover(x))
		MANGAINFO.Authors   = getAuthors(x)
		MANGAINFO.Artists   = getArtists(x)
		MANGAINFO.Genres    = getGenres(x)
		MANGAINFO.Status    = MangaInfoStatusIfPos(getStatus(x))
		MANGAINFO.Summary   = getSummary(x)
		getMangas(x)
		MANGAINFO.ChapterLinks.Reverse(); MANGAINFO.ChapterNames.Reverse()
		return no_error
	else
		return net_problem
	end
end

function getTitle(x)
	local title = ''
	if title == '' then title = x.XPathString('//*[@id="judul"]/h1') end
	if title == '' then title = x.XPathString('//*[@id="judul_komik"]/h1') end
	if title == '' then title = x.XPathString('//div[@class="infox"]/h1') end
	if title == '' then title = x.XPathString('//h1[@itemprop="headline"]') end
	if title == '' then title = x.XPathString('//h1[@itemprop="name"]') end
	if title == '' then title = x.XPathString('//div[@class="info1"]/*') end
	if title == '' then title = x.XPathString('//div[@class="mangainfo"]/h1') end
	if title == '' then title = x.XPathString('//h2[@class="entry-title"]') end
	if title == '' then title = x.XPathString('//h1') end
	if title == '' then title = x.XPathString('//h2') end
	title = title:gsub('Bahasa Indonesia$', ''):gsub(' Indonesia|Baca"', ''):gsub('Bahasa Indonesia', ''):gsub('Komik', ''):gsub(' Raw', '')
	title = title:gsub('Manga', ''):gsub('Indonesia', ''):gsub('Baca', ''):gsub('bahasa', ''):gsub('indonesia', ''):gsub('can', ''):gsub('|', '')
	title = title:gsub(string.gsub(MODULE.Name, 'https://', ''), '')
	return title
end

function getCover(x)
	local img = ''
	if img == '' then img = x.XPathString('//div[@class="series-thumb"]/img/@src') end
	if img == '' then img = x.XPathString('//div[@class="thumb"]/img/@data-lazy-src') end
	if img == '' then img = x.XPathString('//div[@class="thumb"]/img/@data-src') end
	if img == '' then img = x.XPathString('//div[@class="thumb"]/img/@src') end
	if img == '' then img = x.XPathString('//div[@class="imgdesc"]/img/@src') end
	if img == '' then img = x.XPathString('//div[contains(@class,"leftImage")]/img/@src') end
	if img == '' then img = x.XPathString('//div[@class="imgseries"]/img/@src') end
	if img == '' then img = x.XPathString('//div[@itemprop="image"]/img/@src') end
	if img == '' then img = x.XPathString('//div[@class="mangainfo"]//div[@class="topinfo"]/img/@src') end
	if img == '' then img = x.XPathString('//div[@id="m-cover"]/img/@src') end
	if img == '' then img = x.XPathString('//div[@itemprop="image"]/img/@data-lazy-src') end
	if img == '' then img = x.XPathString('//div[@class="img"]/img[@itemprop="image"]/@src') end
	if img == '' then img = x.XPathString('//div[@class="ims"]/img/@src') end
	return img
end

function getAuthors(x)
	local authors = ''
	if authors == '' then authors = x.XPathStringAll('//span[@class="author"]') end
	if authors == '' then authors = x.XPathString('//div[@class="spe"]//span[starts-with(.,"المؤلف")]/substring-after(.,":")') end
	if authors == '' then authors = x.XPathString('//li[starts-with(.,"Komikus")]/b') end
	if authors == '' then authors = x.XPathString('//div[@class="listinfo"]//li[starts-with(.,"Author")]/substring-after(.,":")') end
	if authors == '' then authors = x.XPathString('//span[@class="details"]//div[starts-with(.,"Author")]/substring-after(.,":")') end
	if authors == '' then authors = x.XPathString('//div[@class="preview"]//li[starts-with(.,"Komikus")]/substring-after(.,":")') end
	if authors == '' then authors = x.XPathString('//div[@class="spe"]//span[starts-with(.,"Author")]/substring-after(.,":")') end
	if authors == '' then authors = x.XPathString('//table[@class="attr"]//tr[contains(th, "Author")]/td') end
	if authors == '' then authors = x.XPathString('//table[@class="listinfo"]//tr[contains(th, "Penulis")]/td') end
	if authors == '' then authors = x.XPathString('//*[@class="anf"]//li[starts-with(.,"Author")]/substring-after(.,":")') end
	if authors == '' then authors = x.XPathString('//div[@class="listinfo"]//li[starts-with(.,"Pengarang")]/substring-after(.," ")') end
	if authors == '' then authors = x.XPathString('//span[@id="m-author"]') end
	if authors == '' then authors = x.XPathString('//ul[@class="baru"]/li[2][starts-with(.,"Mangaka")]/substring-after(.,":")') end
	if authors == '' then authors = x.XPathString('//table[@class="listinfo"]//tr[contains(th, "Author")]/following-sibling::td') end
	if authors == '' then authors = x.XPathString('//tr[contains(td, "Komikus")]//following-sibling::td') end
	if authors == '' then authors = x.XPathString('//div[@class="fmed"]/b[starts-with(.,"Author")]//following-sibling::span') end
	if authors == '' then authors = x.XPathString('//td[@itemprop="creator"]') end
	if authors == '' then authors = x.XPathString('//td[contains(., "Author")]/following-sibling::td') end
	return authors
end

function getArtists(x)
	local artists = ''
	if artists == '' then artists = x.XPathString('//div[@class="spe"]//span[starts-with(.,"Artist")]/substring-after(.,":")') end
	if artists == '' then artists = x.XPathString('//div[@class="fmed"]/b[starts-with(.,"Artist")]//following-sibling::span') end
	if artists == '' then artists = x.XPathString('//td[contains(., "Artist")]/following-sibling::td') end
	return artists
end

function getGenres(x)
	local genre = ''
	if genre == '' then genre = x.XPathStringAll('//div[@class="seriestugenre"]/a') end
	if genre == '' then genre = x.XPathStringAll('//span[@class="mgen"]/a') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="spe"]//span[contains(.,"التصنيفات")]/a') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="spe"]//span[starts-with(.,"Genres:")]/substring-after(.,":")') end
	if genre == '' then genre = x.XPathStringAll('//div[contains(@class,"animeinfo")]/div[@class="gnr"]/a') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="gnr"]/a') end
	if genre == '' then genre = x.XPathStringAll('//div[contains(@class,"mrgn animeinfo")]/div[@class="gnr"]/a') end
	if genre == '' then genre = x.XPathStringAll('//span[@id="m-genre"]') end
	if genre == '' then genre = x.XPathStringAll('//table[@class="listinfo"]//tr[contains(th, "Genre")]/td/a') end
	if genre == '' then genre = x.XPathStringAll('//table[@class="attr"]//tr[contains(th, "Genres")]/td/a') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="spe"]//span[starts-with(.,"Genre")]/a') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="spe"]//span[starts-with(.,"Genres")]/a') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="genrex"]/a') end
	if genre == '' then genre = x.XPathStringAll('//ul[@class="genre"]/li') end
	if genre == '' then genre = x.XPathStringAll('//span[@class="details"]//div[starts-with(.,"Genre")]/a') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="listinfo"]//li[starts-with(.,"Genre")]/substring-after(.,":")') end
	if genre == '' then genre = x.XPathStringAll('//div[@class="genre-info"]/a') end
	if genre == '' then genre = x.XPathStringAll('//table[@class="inftable"]//tr[contains(td, "Genres")]/td/a') end
	return genre
end

function getStatus(x)
	local status = ''
	if status == '' then status = x.XPathString('//span[@class="status Ongoing"]') end
	if status == '' then status = x.XPathString('//div[@class="spe"]//span[starts-with(.,"الحالة")]/substring-after(.,":")') end
	if status == '' then status = x.XPathString('//div[@class="spe"]//span[starts-with(.,"Status:")]/substring-after(.,":")') end
	if status == '' then status = x.XPathString('//div[@class="listinfo"]//li[starts-with(.,"Status")]/substring-after(.," ")') end
	if status == '' then status = x.XPathString('//*[@class="anf"]//li[starts-with(.,"Status")]/substring-after(.,":")') end
	if status == '' then status = x.XPathString('//span[@id="m-status"]') end
	if status == '' then status = x.XPathString('//table[@class="listinfo"]//tr[contains(th, "Status")]/td') end
	if status == '' then status = x.XPathString('//table[@class="attr"]//tr[contains(th, "Status")]/td') end
	if status == '' then status = x.XPathString('//div[@class="preview"]//li[starts-with(.,"Tanggal Rilis")]/substring-after(.,"-")') end
	if status == '' then status = x.XPathString('//span[@class="details"]//div[starts-with(.,"Status")]') end
	if status == '' then status = x.XPathString('//ul[@class="baru"]/li[3]') end
	if status == '' then status = x.XPathString('//div[@class="imptdt" and contains(.,"Status")]/i') end
	if status == '' then status = x.XPathString('//td[contains(., "Status")]//following-sibling::td') end
	status = status:gsub('Finished', 'Completed'):gsub('Publishing', 'Ongoing')
	status = status:gsub('Berjalan', 'Ongoing'):gsub('Tamat', 'Completed')
	return status
end

function getSummary(x)
	local summary = ''
	if summary == '' then summary = x.XPathString('//div[@class="series-synops"]/string-join(.//text(),"")') end
	if summary == '' then summary = x.XPathString('//div[@class="sinopsis"]/p') end
	if summary == '' then summary = x.XPathString('//*[@class="desc"]/string-join(.//text(),"")') end
	if summary == '' then summary = x.XPathString('//*[@class="sinopsis"]/string-join(.//text(),"")') end
	if summary == '' then summary = x.XPathString('//*[@id="m-synopsis"]/string-join(.//text(),"")') end
	if summary == '' then summary = x.XPathString('//*[@class="sin"]/p') end
	if summary == '' then summary = x.XPathString('//*[@class="description"]/string-join(.//text(),"")') end
	if summary == '' then summary = x.XPathString('//div[contains(@class,"animeinfo")]/div[@class="rm"]/span/string-join(.//text(),"")') end
	if summary == '' then summary = x.XPathString('//*[@class="jds"]/p') end
	if summary == '' then summary = x.XPathString('//*[@itemprop="description"]/string-join(.//text()[not(parent::script)],"")') end
	summary = summary:gsub('.fb_iframe_widget_fluid_desktop iframe', ''):gsub('width: 100%% !important;', ''):gsub('{', ''):gsub('}', '')
	return summary
end

function getMangas(x)
	if MODULE.ID == '7a74b2abda1d4b329ee1d1fa58866c03' then -- MaidMangaID
		local v for v in x.XPath('//ul[@class="series-chapterlist"]//a').Get() do
			MANGAINFO.ChapterLinks.Add(v.GetAttribute('href'))
			MANGAINFO.ChapterNames.Add(x.XPathString('span[@class="ch"]',v))
		end		
	elseif MODULE.ID == '5c06401129894099bb6fc59c08a878d4' then -- Ngomik
		local v = x.XPath('//div[contains(@class, "bxcl")]//li//*[contains(@class,"lch")]/a')
		for i = 1, v.Count do
			local v1 = v.Get(i)
			local name = v1.GetAttribute('href')
			MANGAINFO.ChapterNames.Add(name:gsub(MODULE.RootURL..'/',''))
			MANGAINFO.ChapterLinks.Add(v1.GetAttribute('href'));
		end
	elseif MODULE.ID == '5af0f26f0d034fb2b42ee65d7e4188ab' then -- Komiku
		x.XPathHREFTitleAll('//td[@class="judulseries"]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames)
	elseif MODULE.ID == '421be2f0d918493e94f745c71090f359' then -- Mangafast
		x.XPathHREFTitleAll('//td[@class="jds"]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames)
	elseif MODULE.ID == 'ca571825056b4850bd3693e4e1437997' then -- Mangacan
		local s
		local v for v in x.XPath('//table[@class="updates"]//td/a').Get() do
			s = v.GetAttribute('href')
			s = string.gsub(s, '-1.htm', '.htm')
			MANGAINFO.ChapterNames.Add(Trim(SeparateLeft(v.ToString(), '')));
			MANGAINFO.ChapterLinks.Add(s);
		end
	else
		-- common
		local v for v in x.XPath('//*[@id="chapterlist"]//*[@class="eph-num"]/a').Get() do
			MANGAINFO.ChapterLinks.Add(v.GetAttribute('href'))
			MANGAINFO.ChapterNames.Add(x.XPathString('span[@class="chapternum"]',v))
		end
		
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//li//span[@class="leftoff"]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//div[@class="bxcl"]//li//*[@class="lchx"]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//div[@class="bxcl"]//li//div[@class="lch"]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//div[@class="bxcl nobn"]//li//div[@class="lch"]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//ul[@class="lcp_catlist"]//li/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//div[contains(@class, "bxcl")]//li//*[contains(@class,"lchx")]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//div[contains(@class, "lchx")]//li//*[contains(@class,"bxcl")]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
		if MANGAINFO.ChapterLinks.Count == 0 then x.XPathHREFAll('//*[@class="lchx"]/a', MANGAINFO.ChapterLinks, MANGAINFO.ChapterNames) end
	end
end

function GetPageNumber()
	if HTTP.GET(MaybeFillHost(MODULE.RootURL, URL)) then
		local x = CreateTXQuery(HTTP.Document)
		if MODULE.ID == '5e66f8a12f114ba3a8408eb1d7044d76' then -- BacaManga
			local crypto = require 'fmd.crypto'
			local s = x.XPathString('*')
			x.ParseHTML(crypto.DecodeBase64(GetBetween('](atob(', ')),', s)))
			x.XPathStringAll('json(*)()', TASK.PageLinks)
		elseif MODULE.ID == '031f3cc0ae3346ad9b8c33d5377891e9' then -- Kiryuu
			local v; for v in x.XPath('//*[@id="readerarea"]//img').Get() do
				if string.find(v.GetAttribute('src'), ".filerun.") == nil and
					string.find(v.GetAttribute('src'), ",0.jpg") == nil and
					string.find(v.GetAttribute('src'), ",5.jpg") == nil and
					string.find(v.GetAttribute('src'), ".5.jpg") == nil and
					string.find(v.GetAttribute('src'), "00.jpg") == nil and
					string.find(v.GetAttribute('src'), "z10.jpg") == nil and
					string.find(v.GetAttribute('src'), "Komeng.jpg") == nil and
					string.find(v.GetAttribute('src'), "ZZ.jpg") == nil and
					string.find(v.GetAttribute('src'), "Iklan.jpg") == nil then
					TASK.PageLinks.Add(v.GetAttribute('src'))
				end
			end
		elseif MODULE.ID == '7103ae6839ea46ec80cdfc2c4b37c803' then -- AsuraScans
			x.XPathStringAll('//*[@id="readerarea"]/p/img[@loading]/@data-src', TASK.PageLinks)
		elseif MODULE.ID == '5af0f26f0d034fb2b42ee65d7e4188ab' then -- Komiku
			x.XPathStringAll('//*[@id="Baca_Komik"]/img/@src', TASK.PageLinks)
		elseif MODULE.ID == '421be2f0d918493e94f745c71090f359' then -- Mangafast
			local v for v in x.XPath('//*[@id="Read"]/img').Get() do
				local src = v.GetAttribute('onerror')
				src = string.match(src, "src='(.*)'")
				TASK.PageLinks.Add(src)
			end
		else
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@class="reader-area"]//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="readerarea"]//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="readerarea"]/p//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="readerarea"]/div//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="readerarea"]//a/@href', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="readerarea"]//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="readerareaimg"]//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="imgholder"]//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@class="entry-content"]//img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@class="bc"]/img/@src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then x.XPathStringAll('//*[@id="chimg"]/img/@data-lazy-src', TASK.PageLinks) end
			if TASK.PageLinks.Count == 0 then
				x.ParseHTML(GetBetween('run(', ');', x.XPathString('//script[contains(., "ts_reader")]')))
				x.XPathStringAll('json(*).sources().images()', TASK.PageLinks)
			end
		end
		return true
	else
		return false
	end
end

function GetNameAndLink()
	if MODULE.ID == '421be2f0d918493e94f745c71090f359' then -- Mangafast
		local dirurl = MODULE.RootURL .. '/list-manga/'
		if not HTTP.GET(dirurl) then return net_problem end
		local x = CreateTXQuery(HTTP.Document)
		x.XPathHREFTitleAll('//*[@class="ranking1"]/a', LINKS, NAMES)
	elseif MODULE.ID == '4efbab5ca3364cd0bb63b776b895262e' then -- manhwatime
		local dirurl = MODULE.RootURL .. '/manhwa/'
		local x = CreateTXQuery()
		local pages = 1
		local p = 1
		local u = dirurl
		while p <= pages do
			if p > 1 then u = dirurl .. 'page/' .. tostring(p) end
			if not HTTP.GET(u) then return net_problem end
			x.ParseHTML(HTTP.Document)
			if p == pages then
				local pg = x.XPathString('//div[@class="pagination"]/span/substring-after(., "Page 1 of ")')
				if pg ~= '' then pages = tonumber(pg) end
			end
			x.XPathHREFTitleAll('//div[@class="animposx"]/a', LINKS, NAMES)
			p = p + 1
		end
	else
		-- full text based list
		local dirs = {
			['49602ce189e844f49bfe78f7a1484dbe'] = '/manga-lists/', -- MangaKid
			['b8206e754d4541689c1d367f7e19fd64'] = '/daftar-komik/?list', -- KomikCast
			['35e1b3ff5dbf428889d0f316c3d881e6'] = '/manga-list/?list', -- WestManga
			['031f3cc0ae3346ad9b8c33d5377891e9'] = '/manga-lists/?list', -- Kiryuu
			['ee7abb21767d48d5b4b343ce701ae6e6'] = '/daftar-manga/?list', -- PecintaKomik
			['63be65ab7f004093ac26fdeb30b466e4'] = '/manga-list/?list', -- MangaIndoNet
			['2cf30e2a7f3d4b4a9b2d29c3fb04e23f'] = '/manga/list-mode/', -- KomikIndoWebId
			['4ccdf84e05474a66adc14ea8a2edfd15'] = '/manga-list/?list', -- KazeManga
			['ca571825056b4850bd3693e4e1437997'] = '/daftar-komik-manga-bahasa-indonesia.html', -- Mangacan
			['fb5bd3aa549f4aefa112a8fe7547d2a9'] = '/manga-list/', -- MangaIndo
			['6f8182f08d5444dbb5244ec882430db1'] = '/manga-list/?list', -- KomikMama
			['7a74b2abda1d4b329ee1d1fa58866c03'] = '/manga-list/', -- MaidMangaID
			['5c06401129894099bb6fc59c08a878d4'] = '/daftar-komik/?list', -- Ngomik
			['c16adc6202924e558b977f74c7301bed'] = '/manga-list/?list', -- MangaPus
			['0a6dd9c339c94a339dbc89c781b20d20'] = '/manga-list/?list', -- Mangaseno
			['f9adee01635a4ff48fdff5164a65d6dd'] = '/manga/list-mode/', -- Komiktap
			['fb34a56c83f54b19b57a9a92070fe899'] = '/manga/list-mode/', -- FlameScans
			['b543e37b656e43ffb3faa034eee6c945'] = '/daftar-manga/?list', -- MangaKita
			['1f1ec10a248c4a4f838c80b3e27fc4c7'] = '/daftar-komik/?list', -- Sekaikomik
			['f68bb6ee00e442418c8c05eb00759ae1'] = '/daftar-manga/?list', -- BacaKomik
			['41294a121062494489adfa601c442ef8'] = '/manga/list-mode/', -- LegionAsia
			['5af0f26f0d034fb2b42ee65d7e4188ab'] = '/daftar-komik/', -- Komiku
			['755ce08dc1a74f69b283cb45b7af56c1'] = '/manga/list-mode/', -- Boosei
			['363066add92f4043b39d2009b442ab32'] = '/manga/list-mode/', -- PhoenixFansub
			['9f756fcbfa114ea4a9abb578004edf31'] = '/manga/list-mode/', -- SkyMangas
			['ec1a1ad5301f414592f0ba0402024813'] = '/komik-list/?list', -- Doujindesu
			['5c06401129894099bb6fc59c08a878d4'] = '/all-komik/?list', -- Ngomik
			['a70859360a2a474ba2abdb86bc48616c'] = '/manga/list-mode/' -- KomikAV
		}
		local dirurl = '/manga/?list'
		if dirs[MODULE.ID] ~= nil then
			dirurl = dirs[MODULE.ID]
		end
		local dirurl = MODULE.RootURL .. dirurl
		if not HTTP.GET(dirurl) then return net_problem end
		local x = CreateTXQuery(HTTP.Document)
		
		x.XPathHREFAll('//*[@class="blix"]//a', LINKS, NAMES)
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@class="daftarkomik"]//a', LINKS, NAMES) end
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@class="jdlbar"]//a', LINKS, NAMES) end
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@class="soralist"]//a', LINKS, NAMES) end
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@id="a-z"]//h4/a', LINKS, NAMES) end
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@class="manga-list"]/a', LINKS, NAMES) end
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@class="ls4j"]//a', LINKS, NAMES) end
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@class="listttl"]//a', LINKS, NAMES) end
		if LINKS.Count == 0 then x.XPathHREFAll('//*[@class="Manga"]/a', LINKS, NAMES) end
	end
	return no_error
end

function BeforeDownloadImage()
	HTTP.Headers.Values['referer'] = MODULE.RootURL
	HTTP.Headers.Values['Accept'] = 'image/webp,image/apng,image/*,*/*'
	return true
end

function Init()
	local cat = 'Indonesian'
	local function AddWebsiteModule(id, name, url)
		local m = NewWebsiteModule()
		m.ID                = id
		m.Name              = name
		m.RootURL           = url
		m.Category          = cat
		m.OnGetInfo         = 'GetInfo'
		m.OnGetPageNumber   = 'GetPageNumber'
		m.OnGetNameAndLink  = 'GetNameAndLink'
		return m
	end
	local m = AddWebsiteModule('5eb57a1843d8462dab0fdfd0efc1eca5', 'MangaShiro', 'https://mangashiro.co')
	m.OnBeforeDownloadImage = 'BeforeDownloadImage'
	AddWebsiteModule('b543e37b656e43ffb3faa034eee6c945', 'MangaKita', 'https://mangakita.net')
	AddWebsiteModule('b5586745030a45bba05d0c360caa6d1a', 'KomikStation', 'https://www.komikstation.com')
	AddWebsiteModule('49602ce189e844f49bfe78f7a1484dbe', 'MangaKid', 'https://mangakid.club')
	AddWebsiteModule('b8206e754d4541689c1d367f7e19fd64', 'KomikCast', 'https://komikcast.com')
	AddWebsiteModule('35e1b3ff5dbf428889d0f316c3d881e6', 'WestManga', 'https://westmanga.info')
	AddWebsiteModule('031f3cc0ae3346ad9b8c33d5377891e9', 'Kiryuu', 'https://kiryuu.co')
	AddWebsiteModule('965d172c0fbd4ad7b75f39fb5cec26ac', 'Kyuroku', 'https://kyuroku.com')
	AddWebsiteModule('5e66f8a12f114ba3a8408eb1d7044d76', 'BacaManga', 'https://bacamanga.co')
	AddWebsiteModule('ee7abb21767d48d5b4b343ce701ae6e6', 'PecintaKomik', 'https://www.pecintakomik.net')
	AddWebsiteModule('63be65ab7f004093ac26fdeb30b466e4', 'MangaIndoNet', 'https://mangaindo.net')
	AddWebsiteModule('009bf49bc17a4a2a8e1c79cce6867651', 'KomikIndo', 'https://komikindo.co')
	AddWebsiteModule('2cf30e2a7f3d4b4a9b2d29c3fb04e23f', 'KomikIndoWebId', 'https://komikindo.web.id')
	AddWebsiteModule('5af0f26f0d034fb2b42ee65d7e4188ab', 'Komiku', 'https://komiku.id')
	AddWebsiteModule('4ccdf84e05474a66adc14ea8a2edfd15', 'KazeManga', 'https://kazemanga.web.id')
	AddWebsiteModule('ca571825056b4850bd3693e4e1437997', 'Mangacan', 'http://www.mangacanblog.com')
	AddWebsiteModule('fb5bd3aa549f4aefa112a8fe7547d2a9', 'MangaIndo', 'https://mangaindo.web.id')
	AddWebsiteModule('6f8182f08d5444dbb5244ec882430db1', 'KomikMama', 'https://komikmama.net')
	AddWebsiteModule('2929eb02fcad4156a6c61576c1dc4b53', 'MangaCeng', 'https://mangaceng.com')
	AddWebsiteModule('7a74b2abda1d4b329ee1d1fa58866c03', 'MaidMangaID', 'https://www.maid.my.id')
	AddWebsiteModule('a70859360a2a474ba2abdb86bc48616c', 'KomikAV', 'https://komikav.com')
	AddWebsiteModule('5c06401129894099bb6fc59c08a878d4', 'Ngomik', 'https://ngomik.net')
	AddWebsiteModule('c16adc6202924e558b977f74c7301bed', 'MangaPus', 'https://mangapus.com')
	AddWebsiteModule('0a6dd9c339c94a339dbc89c781b20d20', 'Mangaseno', 'https://mangaseno.com')
	AddWebsiteModule('56f905ea80e24c4f8bbc37e05de2ad9a', 'Mangakyo', 'https://www.mangakyo.me')
	AddWebsiteModule('76e6db9fe2cf4dd49589cfa9b1174684', 'MataKomik', 'https://matakomik.com')
	AddWebsiteModule('cab72ea1fa4947d29e50ec8751d06c7d', 'KomikGoCoID', 'https://www.komikgo.co.id')
	AddWebsiteModule('d2ffd187eadd4c39819428a160d752cf', 'MangaTsuki', 'https://mangatsuki.web.id')
	AddWebsiteModule('f68bb6ee00e442418c8c05eb00759ae1', 'BacaKomik', 'https://bacakomik.co')
	AddWebsiteModule('755ce08dc1a74f69b283cb45b7af56c1', 'Boosei', 'https://boosei.com')

	cat = 'Webcomics'
	AddWebsiteModule('46dcfabe757140e7980ec34c65bdb30f', 'SekteKomik', 'https://sektekomik.com')
	AddWebsiteModule('e34c929129c74d8aaf8383da9f6ab378', 'BaekjinScans', 'https://baekjinscans.xyz')
	AddWebsiteModule('1f1ec10a248c4a4f838c80b3e27fc4c7', 'SekaiKomik', 'https://www.sekaikomik.com')

	cat = 'Raw'
	AddWebsiteModule('21b0dfcb262d4ae28520679165282666', 'Rawkuma', 'https://rawkuma.com')

	cat = 'Arabic'
	AddWebsiteModule('0e45db2650604f74a0caeb7c1d69a749', 'MangaSWAT', 'https://mangaswat.com')
	
	cat = 'English-Scanlation'
	AddWebsiteModule('7103ae6839ea46ec80cdfc2c4b37c803', 'AsuraScans', 'https://asurascans.com')
	AddWebsiteModule('4efbab5ca3364cd0bb63b776b895262e', 'ManhwaTime', 'https://manhwatime.xyz')
	AddWebsiteModule('fb34a56c83f54b19b57a9a92070fe899', 'FlameScans', 'https://www.flame-scans.com')

	cat = 'H-Sites'
	AddWebsiteModule('f9adee01635a4ff48fdff5164a65d6dd', 'Komiktap', 'https://komiktap.in')
	AddWebsiteModule('ec1a1ad5301f414592f0ba0402024813', 'Doujindesu', 'https://doujindesu.info')

	cat = 'Spanish'
	AddWebsiteModule('41294a121062494489adfa601c442ef8', 'LegionAsia', 'https://legionasia.com')
	AddWebsiteModule('363066add92f4043b39d2009b442ab32', 'PhoenixFansub', 'https://phoenixfansub.com')
	AddWebsiteModule('9f756fcbfa114ea4a9abb578004edf31', 'SkyMangas', 'https://skymangas.com')

	cat = 'English'
	AddWebsiteModule('421be2f0d918493e94f745c71090f359', 'Mangafast', 'https://mangafast.net')
end
