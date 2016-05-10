package com.malalaoshi.android.adapter;

import android.content.res.Resources;
import android.graphics.drawable.AnimationDrawable;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.malalaoshi.android.MalaApplication;
import com.malalaoshi.android.R;
import com.malalaoshi.android.TeacherInfoActivity;
import com.malalaoshi.android.activitys.OrderInfoActivity;
import com.malalaoshi.android.entity.Order;
import com.malalaoshi.android.entity.Teacher;
import com.malalaoshi.android.util.ImageCache;
import com.malalaoshi.android.util.Number;
import com.malalaoshi.android.util.StringUtil;
import com.malalaoshi.android.view.CircleNetworkImage;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;


public class OrderRecyclerViewAdapter extends RecyclerView.Adapter<OrderRecyclerViewAdapter.ViewHolder>{
    private static final int TYPE_NORMAL = 0;
    private static final int TYPE_LOAD_MORE = 1;

    //上拉加载更多
    public static final int  PULLUP_LOAD_MORE=0;
    //正在加载中
    public static final int  LOADING_MORE=1;
    //没有更多数据,到底了
    public static final int NODATA_LOADING = 2;
    //没有更多数据,到底了
    public static final int GONE_LOADING = 3;
    //上拉加载更多状态-默认为0
    private int load_more_status=0;

    public static final int TEACHER_LIST_PAGE_SIZE = 10;

    private  List<Order> orderList;

    private ImageLoader mImageLoader;

    public OrderRecyclerViewAdapter(List<Order> items){
        orderList = items;
        mImageLoader = new ImageLoader(MalaApplication.getHttpRequestQueue(), ImageCache.getInstance(MalaApplication.getInstance()));
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType){
        View view = null;

        switch(viewType){
            case TYPE_LOAD_MORE:
                return new LoadMoreViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.normal_refresh_footer, null));
            default:
                view = LayoutInflater.from(parent.getContext()).inflate(R.layout.order_list_item, null);
                return new NormalViewHolder(view);
        }
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position){
        holder.update(position);
    }

    @Override
    public int getItemCount(){
        if(orderList != null){
            return orderList.size()+1;
        }else{
            return 0;
        }
    }

    @Override
    public int getItemViewType(int position){
        int type = TYPE_NORMAL;
        if (position==getItemCount()-1){
            type = TYPE_LOAD_MORE;
        }
        return type;
    }

    /**
     * //上拉加载更多
     * PULLUP_LOAD_MORE=0;
     * //正在加载中
     * LOADING_MORE=1;
     * //加载完成已经没有更多数据了
     * NO_MORE_DATA=2;
     * @param status
     */
    public void setMoreStatus(int status){
        load_more_status=status;
        notifyDataSetChanged();
    }

    public int getMoreStatus(){
        return load_more_status;
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        protected ViewHolder(View itemView){
            super(itemView);
        }

        protected void update(int position){}
    }

    public class NoValueViewHolder extends ViewHolder{
        protected NoValueViewHolder(View itemView){
            super(itemView);
        }
    }

    public class LoadMoreViewHolder extends ViewHolder{
        @Bind(R.id.item_load_more_icon_loading)
        protected View iconLoading;

        @Bind(R.id.iv_normal_refresh_footer_chrysanthemum)
        protected ImageView ivProgress;

        @Bind(R.id.tv_normal_refresh_footer_status)
        protected TextView tvStatusText;

        protected LoadMoreViewHolder(View itemView){
            super(itemView);
            ButterKnife.bind(this, itemView);
        }

        @Override
        protected void update(int position){
            if (position<=2){
                iconLoading.setVisibility(View.GONE);
            }else{
                iconLoading.setVisibility(View.VISIBLE);
            }
            AnimationDrawable animationDrawable = null;
            switch (load_more_status){
                case PULLUP_LOAD_MORE:
                    tvStatusText.setText("上拉加载更多...");
                    ivProgress.setVisibility(View.GONE);
                    animationDrawable = (AnimationDrawable) ivProgress.getDrawable();
                    animationDrawable.stop();
                    break;
                case LOADING_MORE:
                    tvStatusText.setText("加载中...");
                    ivProgress.setVisibility(View.VISIBLE);
                    animationDrawable = (AnimationDrawable) ivProgress.getDrawable();
                    animationDrawable.start();
                    break;
                case NODATA_LOADING:
                    tvStatusText.setText("到底了,没有更多数据了!");
                    ivProgress.setVisibility(View.GONE);
                    animationDrawable = (AnimationDrawable) ivProgress.getDrawable();
                    animationDrawable.stop();
                    break;
                case GONE_LOADING:
                    //iconLoading.setVisibility(View.GONE);
                    break;
            }

        }

    }

    public class NormalViewHolder extends ViewHolder{

        @Bind(R.id.rl_order_id)
        protected RelativeLayout rlOrderId;

        @Bind(R.id.tv_order_id)
        protected TextView tvOrderId;

        @Bind(R.id.tv_teacher_name)
        protected TextView tvTeacherName;

        @Bind(R.id.iv_teacher_avator)
        protected CircleNetworkImage avater;

        @Bind(R.id.tv_course_name)
        protected TextView tvCourseName;

        @Bind(R.id.tv_course_address)
        protected TextView tvCourseAddress;

        @Bind(R.id.tv_order_status)
        protected TextView tvOrderStatus;

        @Bind(R.id.tv_buy_course)
        protected TextView tvBuyCourse;

        @Bind(R.id.tv_cancel_order)
        protected TextView tvCancelOrder;

        @Bind(R.id.tv_cost)
        protected TextView tvCost;


        protected Order order;

        protected View view;

        protected NormalViewHolder(View itemView){
            super(itemView);
            ButterKnife.bind(this, itemView);
            this.view = itemView;
        }

        @Override
        protected void update(int position){
            if(position >= orderList.size()){
                return;
            }
            order = orderList.get(position);
            tvOrderId.setText(order.getOrder_id());
            tvTeacherName.setText(order.getTeacher());
            tvCourseName.setText(order.getGrade()+" "+order.getSubject());
            tvCourseAddress.setText(order.getSchool());
            String strTopay = "金额异常";
            Double toPay = order.getTo_pay();
            if(toPay!=null){
                strTopay = Number.subZeroAndDot(toPay*0.01d);
            };
            tvCost.setText(strTopay);
            Resources resources = view.getContext().getResources();
            if ("u".equals(order.getStatus())){
                rlOrderId.setBackgroundColor(resources.getColor(R.color.colorPrimary));
                tvOrderStatus.setTextColor(resources.getColor(R.color.theme_red));
                tvOrderStatus.setText("订单待支付");
                tvCancelOrder.setVisibility(View.VISIBLE);
                tvBuyCourse.setVisibility(View.VISIBLE);
                tvBuyCourse.setBackground(resources.getDrawable(R.drawable.bg_pay_order_btn));
                tvBuyCourse.setText("立即支付");
                tvBuyCourse.setTextColor(resources.getColor(R.color.white));
            }else if ("p".equals(order.getStatus())){
                rlOrderId.setBackgroundColor(view.getContext().getResources().getColor(R.color.colorPrimary));
                tvOrderStatus.setTextColor(resources.getColor(R.color.colorPrimary));
                tvOrderStatus.setText("支付成功");
                tvCancelOrder.setVisibility(View.GONE);
                tvBuyCourse.setVisibility(View.VISIBLE);
                tvBuyCourse.setBackground(resources.getDrawable(R.drawable.bg_buy_course_btn));
                tvBuyCourse.setText("再次购买");
                tvBuyCourse.setTextColor(resources.getColor(R.color.theme_red));
            }else if ("d".equals(order.getStatus())){
                rlOrderId.setBackgroundColor(view.getContext().getResources().getColor(R.color.colorDisable));
                tvOrderStatus.setTextColor(resources.getColor(R.color.text_color_dlg));
                tvOrderStatus.setText("订单已关闭");
                tvCancelOrder.setVisibility(View.GONE);
                tvBuyCourse.setVisibility(View.VISIBLE);
                tvBuyCourse.setBackground(resources.getDrawable(R.drawable.bg_buy_course_btn));
                tvBuyCourse.setText("重新购买");
                tvBuyCourse.setTextColor(resources.getColor(R.color.theme_red));

            }else{
                rlOrderId.setBackgroundColor(view.getContext().getResources().getColor(R.color.colorPrimary));
                tvOrderStatus.setTextColor(resources.getColor(R.color.colorLightGreen));
                tvOrderStatus.setText("退款成功");
                tvCancelOrder.setVisibility(View.GONE);
                tvBuyCourse.setVisibility(View.GONE);
            }

            String imgUrl = order.getTeacher_avatar();
            if (TextUtils.isEmpty(imgUrl)) {
                imgUrl = "";
            }
            avater.setDefaultImageResId(R.drawable.ic_default_teacher_avatar);
            avater.setErrorImageResId(R.drawable.ic_default_teacher_avatar);
            avater.setImageUrl(imgUrl, mImageLoader);
        }

        @OnClick(R.id.tv_buy_course)
        protected void onClickBuyCourse(){
            if ("u".equals(order.getStatus())){
                tvBuyCourse.setText("立即支付");
            }else if ("p".equals(order.getStatus())){
                tvOrderStatus.setText("支付成功");
            }else if ("d".equals(order.getStatus())){
                tvOrderStatus.setText("订单已关闭");
            }else{
                tvOrderStatus.setText("退款成功");
            }
        }

        @OnClick(R.id.tv_cancel_order)
        protected void onClickCancelOrder(){
            //取消订单
        }

        @OnClick(R.id.ll_order_item)
        protected void onItemClick(){
            //订单详情
            //OrderInfoActivity.open(this.view.getContext(), order.getOrder_id(), order.getStatus());
        }
    }
}