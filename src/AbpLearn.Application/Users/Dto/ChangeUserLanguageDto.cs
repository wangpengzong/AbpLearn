using System.ComponentModel.DataAnnotations;

namespace AbpLearn.Users.Dto
{
    public class ChangeUserLanguageDto
    {
        [Required]
        public string LanguageName { get; set; }
    }
}