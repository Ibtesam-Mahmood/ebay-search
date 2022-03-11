
import 'package:ebay_search/util/ebay_api.dart';
import 'package:ebay_search/widgets/item_grid_tile.dart';
import 'package:feed/feed.dart';
import 'package:flutter/material.dart';

/// Displays a list of compact feeds which display results from preset search requests
class EbayRecommendedList extends StatelessWidget {
  const EbayRecommendedList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recommended Items', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
            Container(height: 16,),
            const EbayRecommendedFeed(term: 'Phone',),
            Container(height: 16,),
            const EbayRecommendedFeed(term: 'Lamp',),
            Container(height: 16,),
            const EbayRecommendedFeed(term: 'Camera',),
          ],
        ),
      ),
    );
  }
}

/// Displays an individual compact feed to be used in the recommended list
class EbayRecommendedFeed extends StatefulWidget {
  
  /// The search term for the feed
  final String term;

  const EbayRecommendedFeed({ Key? key, required this.term }) : super(key: key);

  @override
  State<EbayRecommendedFeed> createState() => _EbayRecommendedFeedState();
}

class _EbayRecommendedFeedState extends State<EbayRecommendedFeed> {

  final FeedController controller = FeedController(
    gridDelegate: FeedGridViewDelegate(
      padding: const EdgeInsets.all(8)
    )
  );

  /// Builds an item grid tile
  Widget _childBuilder(dynamic item, bool isLast){
    return EbayItemGridTile(item: item);
  }
  
  ///Builds the styling around the feed
  Widget _buildWrapper(BuildContext context, Widget list){

    bool isEmpty = controller.list().isEmpty;
    bool hasMore = controller.hasMore();

    // Widget child = isEmpty ? Center(child: SkeletonMiniPollList()) : list;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Displays search term
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 16),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: 'results for: '),
                TextSpan(text: widget.term, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
              ],
              style: const TextStyle(color: Colors.grey)
            ),
          ),
        ),

        list
        // child
      ],
    );
  }

  Widget _buildViewMoreButton(BuildContext context){

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: (){
          controller.loadMore();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Text(
              'View More',
            )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Feed(
      controller: controller,
      compact: true,
      loader: (size, [token]) => EbayFindingApi.searchItemsByKeywordsFeed(
        keywords: widget.term, 
        size: size, 
        pageToken: token
      ),
      loading: _buildViewMoreButton(context),
      innitalLength: 4,
      lengthFactor: 6,
      childBuilder: _childBuilder,
      wrapper: _buildWrapper,
    );
  }
}