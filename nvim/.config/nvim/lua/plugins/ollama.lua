return {
  "David-Kunz/gen.nvim",
  config = function()
    require("gen").prompts["Elaborate_Text"] = {
      prompt = "Elaborate the following text:\n$text",
      replace = true,
      model = "mistral:instruct",
    }
    require("gen").prompts["Fix_Code"] = {
      prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```",
      model = "mistral:instruct",
    }
    require("gen").prompts["Explain the code to me"] = {
      prompt = "Explain the following $filetype code:\n```\n$text\n```",
      replace = false,
      -- extract = "```$filetype\n(.-)```",
      model = "mistral:instruct",
    }
    require("gen").prompts["add_doc"] = {
      prompt = "Insert some inline documentation to the code but leave the code untouched. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```",
      model = "mistral:instruct",
    }
  end,
}
