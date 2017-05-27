Local config =  require  ' config '
Local u =  requerem  ' utilitários '
Api local =  requerem  ' métodos '

Local plugin = {}

 Função  local antibot_on ( chat_id )
	Local hash =  ' chat: ' .. chat_id .. ' : configurações '
	Local status = db: hget (hash, ' Antibot ' )
	Se status e status ==  ' on '  então
		Return  true
	fim
fim

 Função  local unblockUser ( chat_id, user_id )
	Local hash =  ' chat: ' .. chat_id .. ' : bloqueado '
	Db: hdel (hash, user_id)
fim

 Função  local is_blocked ( chat_id, user_id )
	Local hash =  ' chat: ' .. chat_id .. ' : bloqueado '
	Return db: hexists (hash, user_id)
fim

 Função  local is_locked ( chat_id, coisa )
  	Local hash =  ' chat: ' .. chat_id .. ' : configurações '
  	Local atual = db: hget (hash, coisa)
  	Se atual ==  ' off '  então
  		Return  true
  	outro
  		Return  false
  	fim
fim

 Função  local get_welcome ( msg )
	Se  is_locked (msg. Chat . Id , ' Bem-vindo ' ) então
		Return  false
	fim
	
	Local hash =  ' chat: ' .. msg. conversar . Id . ' : Bem-vindo '
	Local type = (db: hget (hash, ' tipo ' )) ou config. Chat_settings [ ' welcome ' ] [ ' type ' ]
	Local content = (db: hget (hash, ' conteúdo ' )) ou config. Chat_settings [ ' boas-vindas ' ] [ ' conteúdo ' ]
	Se tipo ==  ' mídia '  então
		Local file_id = conteúdo
		Local caption = db: hget (hash, ' legenda ' )
		Se legenda, em seguida, legenda = legenda: replaceholders (msg, true ) end
		Local rules_button = db: hget ( ' chat: ' .. msg. Chat . Id .. ' : settings ' , ' Welbut ' ) ou config. chat_settings [ ' configurações ' ] [ ' Welbut ' ]
		Local reply_markup
		se rules_button ==  ' on '  , em seguida,
			Reply_markup = {inline_keyboard = {{{text =  _ ( ' Leia as regras ' ), url = u. Deeplink_constructor (msg. Chat . Id , ' regras ' )}}}}
		fim
		
		Api. SendDocumentId (msg. Chat . Id , file_id, nil , legenda, reply_markup)
		Return  false
	elseif tipo ==  ' costume '  , em seguida,
		Local reply_markup, new_text = u. Reply_markup_from_text (content)
		Return new_text: replaceholders (msg), reply_markup
	outro
		Return  _ ( " Hi% s! " ): Format (msg. New_chat_member . First_name : escape ())
	fim
fim

 Função  local get_goodbye ( msg )
	se  is_locked (msg. conversar . id , ' Adeus ' ) , em seguida,
		Return  false
	fim
	Local hash =  ' chat: ' .. msg. conversar . id .. ' : adeus '
	
	locais de tipo = db: hget (haxixe, ' tipo ' ) ou  ' personalizado '
	Local content = db: hget (hash, ' conteúdo ' )
	Se tipo ==  ' mídia '  então
		Local file_id = conteúdo
		Local caption = db: hget (hash, ' legenda ' )
		Se legenda, em seguida, legenda = legenda: replaceholders (msg, true ) end
		
		Api. SendDocumentId (msg. Chat . Id , file_id, nil , legenda)
		Return  false
	elseif tipo ==  ' costume '  , em seguida,
		Se  não conteúdo então
			Local name = msg. Left_chat_member . First_name : escape ()
			Se msg. Left_chat_member . Nome de usuário  então
				Nome = nome: escape () ..  ' (@ '  .. msg. Left_chat_member . Nome de usuário : escape () ..  ' ) '
			fim
			Return  _ ( " Adeus,% s! " ): Formato (nome)
		fim
		Return content: replaceholders (msg)
	fim
fim

Função  plugin. OnTextMessage ( msg, blocos )
    Se os blocos [ 1 ] ==  ' bem-vindo '  então
        
        Se msg. conversar . Digite  ==  ' privado '  ou  não u. is_allowed ( ' textos ' , msg. conversar . id , msg. de ) , em seguida,  retornar  final
        
        Entradas locais = blocos [ 2 ]
        
        Se  não entrada e  não msg. Responda  então
			Api. SendReply (msg, _ ( " Bem-vindo e ...? " )) Return
        fim
        
        Local hash =  ' chat: ' .. msg. conversar . Id . ' : Bem-vindo '
        
        Se  não entrada e msg. Responda  então
            Local respondeu_to = u. Get_media_type ( resposta msg )
            Se reply_to ==  ' adesivo '  ou reply_to ==  ' gif '  então
                Local file_id
                Se reply_to ==  ' adesivo '  então
                    File_id = msg. Resposta . Etiqueta . File_id
                outro
                    File_id = msg. Resposta . Documento . File_id
                fim
                Db: hset (hash, ' tipo ' , ' media ' )
                Db: hset (hash, ' conteúdo ' , file_id)
                Se msg. Resposta . Legenda  então
                	db: HAjuste (hash ' subtítulo ' ., msg resposta . subtítulo )
                outro
                	Db: hdel (hash, ' legenda ' ) - remove a legenda se a nova mídia não tiver uma legenda
                fim
				- ativar a mensagem de boas-vindas nas configurações do grupo
				Db: hset (( ' chat:% d: settings ' ): formato (msg. Chat . Id ), ' Bem-vindo ' , ' on ' )
                Api. SendReply (msg, _ ( " Uma forma de mídia foi definida como a mensagem de boas-vindas:`% s` " ): format (respondeu_to), true )
            outro
                Api. SendReply (msg, _ ( " Responder a um` adesivo` ou `` gif` para defini-los como a mensagem de boas-vindas * " ), true )
            fim
        outro
            db: HColoque (haxixe, ' tipo ' , ' costume ' )
            Db: hset (hash, ' conteúdo ' , entrada)
            
            Local reply_markup, new_text = u. Reply_markup_from_text (entrada)
            
            Res local , code = api. SendReply (MSG, novo_texto: gsub ( ' $ regras ' ., u deeplink_constructor . (msg conversar . id , ' regras ' )), verdadeira , reply_markup)
            Se  não res , então
                Db: hset (hash, ' type ' , ' no ' ) - se markdown errado, remova 'custom' novamente
                Db: hset (hash, ' conteúdo ' , ' não ' )
                Api. SendMessage (msg. Chat . Id , u. Get_sm_error_string (código), true )
            outro
				- ativar a mensagem de boas-vindas nas configurações do grupo
				Db: hset (( ' chat:% d: settings ' ): formato (msg. Chat . Id ), ' Bem-vindo ' , ' on ' )
                Id local = res. Resultado . Message_id
                Api. EditMessageText (msg. Chat . Id , id, _ ( " * Mensagem de boas-vindas personalizada salva! * " ), True )
            fim
        fim
    fim
	Se os blocos [ 1 ] ==  ' adeus '  então
		Se msg. conversar . Digite  ==  ' privado '  ou  não u. is_allowed ( ' textos ' , msg. conversar . id , msg. de ) , em seguida,  retornar  final

		Entradas locais = blocos [ 2 ]
		Local hash =  ' chat: ' .. msg. conversar . id .. ' : adeus '

		- ignorar se não inserir texto e não responder
		Se  não entrada e  não msg. Responda  então
			Api. SendReply (msg, _ ( " Sem mensagem de adeus " ), false )
			Retorna
		fim

		Se  não entrada e msg. Responda  então
			Local respondeu_to = u. Get_media_type ( resposta msg )
			Se reply_to ==  ' adesivo '  ou reply_to ==  ' gif '  então
				Local file_id
				Se reply_to ==  ' adesivo '  então
					File_id = msg. Resposta . Etiqueta . File_id
				outro
					File_id = msg. Resposta . Documento . File_id
				fim
				Db: hset (hash, ' tipo ' , ' media ' )
				Db: hset (hash, ' conteúdo ' , file_id)
				Se msg. Resposta . Legenda  então
                	db: HAjuste (hash ' subtítulo ' ., msg resposta . subtítulo )
                outro
                	Db: hdel (hash, ' legenda ' ) - remove a legenda se a nova mídia não tiver uma legenda
                fim
				- ative a mensagem de adeus nas configurações do grupo
				db: HColoque (( ' chat:% d: configurações ' ): formato . (msg conversar . id ), ' Adeus ' , ' on ' )
				
				Api. SendReply (msg, _ ( " Nova mídia definida como mensagem de adeus:`% s` " ): format (respondeu_to), true )
			outro
				Api. SendReply (msg, _ ( " Responda a um` adesivo` ou `` gif` para defini-los como * mensagem de adeus * " ), true )
			fim
			Retorna
		fim

		Entrada = entrada: gsub ( ' ^% s * (.-)% s * $ ' , ' % 1 ' ) - espaços de recorte
		db: HColoque (haxixe, ' tipo ' , ' costume ' )
		Db: hset (hash, ' conteúdo ' , entrada)
		Res local , code = api. SendReply (msg, input, true )
		Se  não res , então
			Db: hset (hash, ' tipo ' , ' composto ' ) - se markdown errado, remova 'custom' novamente
			Db: hset (hash, ' conteúdo ' , ' não ' )
			Api. SendMessage (msg. Chat . Id , u. Get_sm_error_string (código), true )
		outro
			- ative a mensagem de adeus nas configurações do grupo
			db: HColoque (( ' chat:% d: configurações ' ): formato . (msg conversar . id ), ' Adeus ' , ' on ' )
			Id local = res. Resultado . Message_id
			Api. EditMessageText (msg. Chat . Id , id, _ ( " * Mensagem de despedida personalizada salva! * " ), True )
		fim
	fim
    Se blocos [ 1 ] ==  ' new_chat_member '  então
		Se  não msg. Serviço,  em seguida,  retornar  final
		
		Extra local
		Se msg. De . Id  ~ = msg. New_chat_member . Id  então extra = msg. Do  fim
		você. LogEvent (blocos [ 1 ], msg, extra)
		
		Se  is_blocked (msg. Chat . Id , msg. New_chat_member . Id ) e  não msg. De . Mod  então
			Local res = api. BanUser (msg. Chat . Id , msg. New_chat_member . Id )
			Se res então
				unblockUser (msg. conversa . id , msg. new_chat_member . ID )
				Nome local = u. Getname_final (msg. New_chat_member )
				Api. sendMessage (. msg bate-papo . id , _ ( " % s proibido: o usuário foi bloqueado " ): formato (nome), ' html ' )
				você. LogEvent ( ' blockban ' , msg, {nome = nome, id = msg. New_chat_member . Id })
			fim
			Retorna
		fim
		
		Se msg. New_chat_member . Nome de usuário
			E  não msg. New_chat_member . último nome
			E msg. De . Id  ~ = msg. New_chat_member . Id  então
				
				Local username = msg. New_chat_member . Username : lower ()
				Se username: find ( ' bot ' , - 3 ) então
					Se  antibot_on (msg. Chat . Id ) e  não msg. De . Mod  então
						Api. sendMessage (. msg bate-papo . id , _ ( " @% s _banned: Antibot é on_ " ): formato . (msg new_chat_member . Nome de usuário : fuga ()), verdadeiro )
						Api. BanUser (msg. Chat . Id , msg. New_chat_member . Id )
					fim
					Retorna
				fim
		fim
		
		Texto local , reply_markup =  get_welcome (msg)
		Se o texto então  - se não o texto: bem-vindo está bloqueado ou é um gif / adesivo
			Local attach_button = (db: hget ( ' chat: ' .. msg. Chat . Id .. ' : settings ' , ' Welbut ' )) ou config. chat_settings [ ' configurações ' ] [ ' Welbut ' ]
			se attach_button ==  ' on '  , em seguida,
				Se  não reply_markup then reply_markup = {inline_keyboard = {}} end
				Linha local = {{text =  _ ( ' Leia as regras ' ), url = u. Deeplink_constructor (msg. Chat . Id , ' rules ' )}}
				Table.insert (reply_markup. Inline_keyboard , line)
			fim
			Local link_preview = texto: find ( ' telegra% .ph / ' ) ~ =  nil
			Api. sendMessage (msg. conversa . id , texto, verdadeiro , reply_markup, nil , link_preview)
		fim
		
		Local send_rules_private = db: hget ( ' user: ' .. msg. New_chat_member . Id .. ' : settings ' , ' rules_on_join ' )
		Se send_rules_private e send_rules_private ==  ' on '  então
		    Regras locais = db: hget ( ' chat: ' .. msg. Chat . Id .. ' : info ' , ' rules ' )
		    Se as regras então
		        Api. SendMessage (msg. New_chat_member . Id , rules, true )
		    fim
	    fim
	fim
	Se blocos [ 1 ] ==  ' left_chat_member '  então
		Se  não msg. Serviço,  em seguida,  retornar  final

		Se msg. Left_chat_member . Username  e msg. Left_chat_member . Username : lower (): find ( ' bot ' , - 3 ) e depois  return  end
		Texto local =  get_goodbye (msg)
		Se o texto então
			Local link_preview = texto: find ( ' telegra% .ph / ' ) ~ =  nil
			Api. SendMessage (msg. Chat . Id , texto, true , nil , nil , link_preview)
		fim
	fim
fim

plugar. Triggers  = {
	OnTextMessage = {
		Config. Cmd .. ' (bem-vindo) (. *) $ ' ,
		Config. Cmd .. ' set (welcome) (. *) $ ' ,
		Config. Cmd .. ' (bem-vindo) $ ' ,
		Config. Cmd .. ' set (welcome) $ ' ,
		Config. Cmd .. ' (adeus) (. *) $ ' ,
		Config. Cmd .. ' set (adeus) (. *) $ ' ,
		Config. Cmd .. ' (adeus) $ ' ,
		Config. Cmd .. ' set (adeus) $ ' ,

		' ^ ### (new_chat_member) $ ' ,
		' ^ ### (left_chat_member) $ ' ,
	}
}

Retornar plugin
