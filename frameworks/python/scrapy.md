# Scrapy
> Senior Scrapy architect. Inherits: python/_base.md

Detection: `scrapy.cfg` + `settings.py` with `BOT_NAME` + `scrapy` in deps
Commands: crawl=`scrapy crawl [name]` output=`scrapy crawl [name] -o output.json` shell=`scrapy shell "URL"` list=`scrapy list` test=`pytest` lint=`ruff check .`

Conventions:
- One spider per source in `spiders/` -- define data structure with `scrapy.Item` or dataclasses
- Item Pipelines for processing/validation/storage -- `DropItem` to skip invalid items
- CSS selectors preferred over XPath; yield items and requests, never return lists
- `custom_settings` on spider class to override project settings per spider
- `ROBOTSTXT_OBEY = True` + `DOWNLOAD_DELAY` + `AUTOTHROTTLE_ENABLED` for respectful crawling
- Request/response middleware for headers, proxies, retries

Error: `errback` on `Request` for failed requests; `DropItem` in pipelines for invalid items; `RETRY_TIMES` for auto-retries; `self.logger` for spider-level logging
Test: pytest + `scrapy.http.HtmlResponse` for mock responses | Betamax/VCR.py for replay | Unit: parsing logic, pipeline processing | Integration: full spider vs local test server | Contract: docstring spider contracts
Structure: `project/{__init__.py,items.py,middlewares.py,pipelines.py,settings.py,spiders/}` + `tests/{test_spiders.py,fixtures/}` + `scrapy.cfg`

Convention Block:
- One spider per source in spiders/
- Items define data structure -- validate in pipelines
- CSS selectors preferred over XPath
- Yield items and follow-up requests -- never return
- ROBOTSTXT_OBEY + DOWNLOAD_DELAY for respectful crawling
- Test parsing logic with mock HtmlResponse objects

.gitignore Additions:
> Base: see python/_base.md
*.json, *.csv, .scrapy/

Pitfalls:
- Returning items instead of yielding them
- Not handling pagination -- missing `yield scrapy.Request(next_page)`
- Ignoring robots.txt and rate limits -- gets IP banned
- Hardcoding selectors that break on site layout changes
- Not using Item Loaders for complex field processing
