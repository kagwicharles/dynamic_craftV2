part of dynamic_widget;

class LoadUtil extends StatelessWidget {
  const LoadUtil({super.key});

  @override
  Widget build(BuildContext context) =>
      Lottie.asset("packages/craft_dynamic/assets/lottie/loading_list.json");
}

class EmptyUtil extends StatelessWidget {
  const EmptyUtil({super.key});

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "packages/craft_dynamic/assets/images/empty.png",
            height: 64,
            width: 64,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 14,
          ),
          const Text(
            "Nothing found!",
            
          )
        ],
      ));
}
