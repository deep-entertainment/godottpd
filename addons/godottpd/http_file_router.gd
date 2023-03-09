# Class inheriting HttpRouter for handling file serving requests
extends HttpRouter
class_name HttpFileRouter

# Full path to the folder which will be exposed to web
var path: String = ""

# Relative path to the index page, which will be served when a request is made to "/" (server root)
var index_page: String = "index.html"

# Relative path to the fallback page which will be served if the requested file was not found
var fallback_page: String = ""

# An ordered list of extensions that will be checked
# if no file extension is provided by the request
var extensions: PackedStringArray = ["html"]

# A list of extensions that will be excluded if requested
var exclude_extensions: PackedStringArray = []

# Creates an HttpFileRouter intance
#
# #### Parameters
# - path: Full path to the folder which will be exposed to web
# - options: Optional Dictionary of options which can be configured.
# 	- fallback_page: Full path to the fallback page which will be served if the requested file was not found
#	- extensions: A list of extensions that will be checked if no file extension is provided by the request
# 	- exclude_extensions: A list of extensions that will be excluded if requested
func _init(
	path: String,
	options: Dictionary = {
		index_page = index_page,
		fallback_page = fallback_page,
		extensions = extensions,
		exclude_extensions = exclude_extensions,
	}
	) -> void:
	self.path = path
	self.index_page = options.get("index_page", "")
	self.fallback_page = options.get("fallback_page", "")
	self.extensions = options.get("extensions", [])
	self.exclude_extensions = options.get("exclude_extensions", [])

# Handle a GET request
func handle_get(request: HttpRequest, response: HttpResponse) -> void:
	var serving_path: String = path + request.path
	var file_exists: bool = _file_exists(serving_path)

	if request.path == "/" and not file_exists:
		if index_page.length() > 0:
			serving_path = path + "/" + index_page
			file_exists = _file_exists(serving_path)

	if request.path.get_extension() == "" and not file_exists:
		for extension in extensions:
			serving_path = path + request.path + "." + extension
			file_exists = _file_exists(serving_path)
			if file_exists:
				break

	# GDScript must be excluded, unless it is used as a preprocessor (php-like)
	if (file_exists and not serving_path.get_extension() in ["gd"] + Array(exclude_extensions)):
		response.send_raw(
			200,
			_serve_file(serving_path),
			_get_mime(serving_path.get_extension())
			)
	else:
		if fallback_page.length() > 0:
			serving_path = path + "/" + fallback_page
			response.send_raw(200 if index_page == fallback_page else 404, _serve_file(serving_path), _get_mime(fallback_page.get_extension()))
		else:
			response.send_raw(404)

# Reads a file as text
#
# #### Parameters
# - file_path: Full path to the file
func _serve_file(file_path: String) -> PackedByteArray:
	var content: PackedByteArray = []
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var error = file.get_open_error()
	if error:
		content = ("Couldn't serve file, ERROR = %s" % error).to_ascii_buffer()
	else:
		content = file.get_buffer(file.get_length())
	file.close()
	return content

# Check if a file exists
#
# #### Parameters
# - file_path: Full path to the file
func _file_exists(file_path: String) -> bool:
	return FileAccess.file_exists(file_path)

# Get the full MIME type of a file from its extension
#
# #### Parameters
# - file_extension: Extension of the file to be served
func _get_mime(file_extension: String) -> String:
	var type: String = "application"
	var subtype : String = "octet-stream"
	match file_extension:
		# Web files
		"css","html","csv","js","mjs":
			type = "text"
			subtype = "javascript" if file_extension in ["js","mjs"] else file_extension
		"php":
			subtype = "x-httpd-php"
		"ttf","woff","woff2":
			type = "font"
			subtype = file_extension
		# Image
		"png","bmp","gif","png","webp":
			type = "image"
			subtype = file_extension
		"jpeg","jpg":
			type = "image"
			subtype = "jpg"
		"tiff", "tif":
			type = "image"
			subtype = "jpg"
		"svg":
			type = "image"
			subtype = "svg+xml"
		"ico":
			type = "image"
			subtype = "vnd.microsoft.icon"
		# Documents
		"doc":
			subtype = "msword"
		"docx":
			subtype = "vnd.openxmlformats-officedocument.wordprocessingml.document"
		"7z":
			subtype = "x-7x-compressed"
		"gz":
			subtype = "gzip"
		"tar":
			subtype = "application/x-tar"
		"json","pdf","zip":
			subtype = file_extension
		"txt":
			type = "text"
			subtype = "plain"
		"ppt":
			subtype = "vnd.ms-powerpoint"
		# Audio
		"midi","mp3","wav":
			type = "audio"
			subtype = file_extension
		"mp4","mpeg","webm":
			type = "audio"
			subtype = file_extension
		"oga","ogg":
			type = "audio"
			subtype = "ogg"
		"mpkg":
			subtype = "vnd.apple.installer+xml"
		# Video
		"ogv":
			type = "video"
			subtype = "ogg"
		"avi":
			type = "video"
			subtype = "x-msvideo"
		"ogx":
			subtype = "ogg"
	return type + "/" + subtype
