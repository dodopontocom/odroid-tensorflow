#!/bin/bash
#
BASEDIR=$(dirname $0)
source ${BASEDIR}/ShellBot.sh
source ${BASEDIR}/random.sh
bot_token=$1
bot_version=$(tail -1 ${BASEDIR}/../VERSION)
DOCKER_IMAGE=rodolfoneto/tensorflow-retrained-experience
DOCKER_SCRIPTS_DIRECTORY: /home/tensorflowEx/scripts

ShellBot.init --token "$bot_token" --monitor
ShellBot.username

while :
do
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	for id in $(ShellBot.ListUpdates)
	do
	# Inicio thread
	(
		# Desativa download
		download_file=0

		# Lê a atualização armazenada em 'id'
		if [ "${update_id[$id]}" ]; then
			[[ ${message_photo_file_id[$id]} ]] && file_id=${message_photo_file_id[$id]} && download_file=1
			[[ $download_file -eq 1 ]] && {
				dest_file=${BASEDIR}/
				imageLab=${BASEDIR}/supermarket_labels.txt
				file_id=($file_id)
				getFile_id=$(echo ${file_id[@]} | cut -d'|' -f3)
				file_final=$(ShellBot.getFile --file_id "$getFile_id" | cut -d'|' -f4)
				file_path=$(ShellBot.downloadFile --file_path "${file_final}" --dir "$dest_file") && {

					file_path=$(echo $file_path | cut -d'|' -f2 | sed 's#\.\/##')
					
					msg="\`(versão beta: $bot_version)\`\n"
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
						--text "$(echo -e "$msg")" \
						--parse_mode markdown
					msg="*Download da imagem realizado com sucesso.*\n\n"
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
						--text "$(echo -e "$msg")" \
						--parse_mode markdown
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
						--text "Processando, aguarde uns instantes..." \
						--parse_mode markdown
					
					get_random="/tmp/$(random.helper).log"
					message=$(docker run --rm -i -v ${PWD}:/home/tensor-photos $DOCKER_IMAGE python label.py "/home/tensor-photos/$(echo $file_path)" > $get_random)
					produto=$(tail -3 $get_random | head -1)
					if [[ $? -eq 0 ]] && [[ "$produto" != "---" ]]; then
						assertividade="\`(assertividade: $(tail -2 $get_random | head -1))\`\n"
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "$(echo -e $assertividade)" \
								--parse_mode markdown
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "Produto: $(echo -e $produto)" \
								--parse_mode markdown
					else
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "Erro ao processar, tente outra imagem..." \
								--parse_mode markdown
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "Atente-se à luminosidade e a nitidez do rótulo do produto!" \
								--parse_mode markdown
					fi

					if [[ "$produto" != "---" ]]; then
						resultado=$(cat $imageLab | grep -i "$produto")
						if [[ ! -z $resultado ]]; then
							valor=$(cat $imageLab | grep -i "$produto:" | cut -d':' -f2)
							if [[ ! -z $valor ]]; then
								ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
										--text "Valor: $(echo ${valor})" \
										--parse_mode markdown
							else
								msg="Valor não registrado para o produto \`$produto\`"
								ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
										--text "$(echo -e ${msg})" \
										--parse_mode markdown						
							fi
						else
							msg="Produto não cadastrado em nosso banco de dados."
								ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
										--text "$(echo -e ${msg})" \
										--parse_mode markdown
						fi
					fi
					elapsed="\`(tempo de processamento: $(tail -1 $get_random) segundos)\`\n"
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "$(echo -e $elapsed)" \
								--parse_mode markdown
				}
				rm -f $file_path
			}
		fi
	) &
	done
done
#end
