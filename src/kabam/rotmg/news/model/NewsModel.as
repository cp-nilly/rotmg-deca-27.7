package kabam.rotmg.news.model
{
    import com.company.assembleegameclient.parameters.Parameters;

    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.news.controller.NewsButtonRefreshSignal;
    import kabam.rotmg.news.controller.NewsDataUpdatedSignal;
    import kabam.rotmg.news.view.NewsModalPage;

    public class NewsModel
    {
        private static const COUNT:int = 3;
        public static const MODAL_PAGE_COUNT:int = 4;
        [Inject]
        public var update:NewsDataUpdatedSignal;
        [Inject]
        public var updateNoParams:NewsButtonRefreshSignal;
        [Inject]
        public var account:Account;
        public var news:Vector.<NewsCellVO>;
        public var modalPages:Vector.<NewsModalPage>;
        public var modalPageData:Vector.<NewsCellVO>;

        public function initNews():void
        {
            this.news = new Vector.<NewsCellVO>(COUNT, true);
            var _local1:int;
            while (_local1 < COUNT)
            {
                this.news[_local1] = new DefaultNewsCellVO(_local1);
                _local1++;
            }
        }

        public function updateNews(_arg1:Vector.<NewsCellVO>):void
        {
            var _local3:NewsCellVO;
            var _local4:int;
            var _local5:int;
            this.initNews();
            var _local2:Vector.<NewsCellVO> = new Vector.<NewsCellVO>();
            this.modalPageData = new Vector.<NewsCellVO>(4, true);
            for each (_local3 in _arg1)
            {
                if (_local3.slot <= 3)
                {
                    _local2.push(_local3);
                }
                else
                {
                    _local4 = (_local3.slot - 4);
                    _local5 = (_local4 + 1);
                    this.modalPageData[_local4] = _local3;
                    if (Parameters.data_[("newsTimestamp" + _local5)] != _local3.endDate)
                    {
                        Parameters.data_[("newsTimestamp" + _local5)] = _local3.endDate;
                        Parameters.data_[("hasNewsUpdate" + _local5)] = true;
                    }
                }
            }
            this.sortByPriority(_local2);
            this.update.dispatch(this.news);
            this.updateNoParams.dispatch();
        }

        public function hasValidNews():Boolean
        {
            return (((((!((this.news[0] == null))) && (!((this.news[1] == null))))) && (!((this.news[2] == null)))));
        }

        public function hasValidModalNews():Boolean
        {
            var _local1:int;
            while (_local1 < MODAL_PAGE_COUNT)
            {
                if (this.modalPageData[_local1] == null)
                {
                    return (false);
                }
                _local1++;
            }
            return (true);
        }

        private function sortByPriority(_arg1:Vector.<NewsCellVO>):void
        {
            var _local2:NewsCellVO;
            for each (_local2 in _arg1)
            {
                if (((this.isNewsTimely(_local2)) && (this.isValidForPlatform(_local2))))
                {
                    this.prioritize(_local2);
                }
            }
        }

        private function prioritize(_arg1:NewsCellVO):void
        {
            var _local2:uint = (_arg1.slot - 1);
            if (this.news[_local2])
            {
                _arg1 = this.comparePriority(this.news[_local2], _arg1);
            }
            this.news[_local2] = _arg1;
        }

        private function comparePriority(_arg1:NewsCellVO, _arg2:NewsCellVO):NewsCellVO
        {
            return ((((_arg1.priority) < _arg2.priority) ? _arg1 : _arg2));
        }

        private function isNewsTimely(_arg1:NewsCellVO):Boolean
        {
            var _local2:Number = new Date().getTime();
            return ((((_arg1.startDate < _local2)) && ((_local2 < _arg1.endDate))));
        }

        public function buildModalPages():void
        {
            if (!this.hasValidModalNews())
            {
                return;
            }
            this.modalPages = new Vector.<NewsModalPage>(MODAL_PAGE_COUNT, true);
            var _local1:int;
            while (_local1 < MODAL_PAGE_COUNT)
            {
                this.modalPages[_local1] = new NewsModalPage(
                        (this.modalPageData[_local1] as NewsCellVO).headline,
                        (this.modalPageData[_local1] as NewsCellVO).linkDetail
                );
                _local1++;
            }
        }

        public function getModalPage(_arg1:int):NewsModalPage
        {
            if (((((((!((this.modalPages == null))) && ((_arg1 > 0)))) && ((_arg1 <= this.modalPages.length)))) && (!((this.modalPages[(_arg1 - 1)] == null)))))
            {
                return (this.modalPages[(_arg1 - 1)]);
            }
            return (new NewsModalPage("No new information", "Please check back later."));
        }

        private function isValidForPlatform(_arg1:NewsCellVO):Boolean
        {
            var _local2:String = this.account.gameNetwork();
            return (!((_arg1.networks.indexOf(_local2) == -1)));
        }
    }
}

