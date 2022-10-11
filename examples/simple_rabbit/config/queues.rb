Isometric::Config.instance.set_config('person_queues') do
  create 'person_create'
  update 'person_update'
  delete 'person_delete'
end