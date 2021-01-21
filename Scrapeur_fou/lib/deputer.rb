require 'nokogiri'
require 'open-uri'
$principal_adress="https://www2.assemblee-nationale.fr"
doc = Nokogiri::HTML(URI.open('https://www2.assemblee-nationale.fr/deputes/liste/alphabetique'))
#tableau de hash avec : prénom nom et email

def fusiontab(tab1,tab2)
    return Hash[tab1.zip(tab2)]
end


def get_mail(array_final,array_link)
    puts"va te pendre taura le temps de crever le temps que cette fonction finisse :')"
    array_link.each{|link|
    page = Nokogiri::HTML(URI.open($principal_adress+link))
    mail = page.xpath('//dd[4]//li[2]/a').text
    array_final<<mail
    }
    return array_final
end

def deputes(pages)
    array_of_first_name=[]
    array_of_name=[]
    array_of_mail=[]
    array_of_link=[]
    tab=[]

    links=pages.xpath('//*[@id="deputes-list"]//a')
    links.each{|link|
    array_of_link<<link['href']
    }
    links.each{|link|
    array_of_name<<link.text
    array_of_mail.delete("")
    for i in 0..array_of_first_name.length-1
        tab[i]=array_of_first_name[i].to_s+" ".to_s+array_of_mail[i].to_s
    end
    }
    for i in 0..array_of_name.length-1
        if array_of_name[i][0..2]=="Mme"
            array_of_name[i][0..3]=array_of_name[i][0..3].delete("Mme ")
        elsif array_of_name[i][0..2]=="M. "
            array_of_name[i][0..2]=array_of_name[i][0..2].delete("M. ")
        elsif array_of_name[i][0..1]=="M "
            array_of_name[i][0..1]=array_of_name[i][0..1].delete("M ")
        end
    end
    array_of_name.delete("")
    array_of_link=array_of_link.compact
    array_of_name.each{|name|
    array_of_first_name<<name
    }
    puts"voici le nom des députers de france"
    print array_of_first_name
    puts
    array_of_mail=get_mail(array_of_mail,array_of_link)
    array_of_mail.delete("")
    puts"voila la liste des email de tout les députés que j'ai pu trouvé !!!!!!!!!!!!!"
    print array_of_mail
end
deputes(doc)
