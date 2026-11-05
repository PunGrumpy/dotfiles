local TS = require("nvim-treesitter")

local ensure_installed = {
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"fish",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"graphql",
	"hcl",
	"helm",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"json5",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"printf",
	"prisma",
	"python",
	"query",
	"regex",
	"ron",
	"rust",
	"scss",
	"sql",
	"svelte",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

local function install_parsers()
	TS.install(ensure_installed)
end

-- Compiling parsers needs the tree-sitter CLI, which Mason may still be installing.
if vim.fn.executable("tree-sitter") == 1 then
	install_parsers()
else
	vim.api.nvim_create_autocmd("User", {
		pattern = "MasonToolsUpdateCompleted",
		once = true,
		callback = install_parsers,
	})
end

require("treesitter-autoinstall").setup()

-- MDX has no parser of its own; render it with the Markdown one.
vim.filetype.add({ extension = { mdx = "mdx" } })
vim.treesitter.language.register("markdown", "mdx")

local function helm_or_yaml(path)
	return vim.fs.root(path, "Chart.yaml") and "helm" or "yaml"
end

vim.filetype.add({
	pattern = {
		[".*/templates/.*%.ya?ml"] = helm_or_yaml,
		[".*/templates/.*%.tpl"] = helm_or_yaml,
		[".*/playbooks?/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
		[".*/site%.ya?ml"] = "yaml.ansible",
	},
})
vim.treesitter.language.register("yaml", "yaml.ansible")

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterIndent", { clear = true }),
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if lang and vim.treesitter.language.add(lang) then
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
