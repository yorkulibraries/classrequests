// CONTROL ACTION TEXT FILE ATTACHMENTS USED IN REQUEST NOTES AND INSTRUCTOR NOTES
window.addEventListener('trix-file-accept', function(event) {
  // event.preventDefault()
  // alert('File attachment not supported!')
  const acceptedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation']
  if (!acceptedTypes.includes(event.file.type)) {
    event.preventDefault()
    alert('Only support attachment of jpeg, jpg, png, word, excel, powerpoint, pdf files')
  }
  const maxFileSize = 10485760 // = 10mb //1024 * 1024 = 1MB | 25mb = 25600 // 5mb = 5242880 bytes
  if (event.file.size > maxFileSize) {
    event.preventDefault()
    alert('Only support attachment files upto size 10MB!')
  }
})
