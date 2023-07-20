enum AnimationList {
  loading('assets/animations/loading.json'),
  user('assets/animations/user.json');

  const AnimationList(this.value);

  final String value;
}

// extension AnimationListValue on AnimationList {
//   String get value {
//     switch (this) {
//       case AnimationList.loading:
//         return 'loading.json';
//       case AnimationList.user:
//         return 'user.json';
//     }
//   }
// }
