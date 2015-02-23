#include <stdio.h>
#include <curl/curl.h>
#include <string.h>

CURL *curl;
CURLcode res;

size_t write_data(void *buffer, size_t size, size_t nmemb, void *user_p){
    FILE *fp = (FILE*)user_p;
    size_t return_size = fwrite(buffer,size,nmemb,fp);
    return return_size;
}

size_t progress_func(char *progress_data, double dltotal, double dlnow,double ultotal, double ulnow){
    printf("%s %g / %g (%g %%)\n", progress_data, dlnow, dltotal, dlnow*100.0/dltotal);
    return 0;
}

int main(){
    CURLcode return_code;
    return_code = curl_global_init(CURL_GLOBAL_ALL);        // initialize everything possible
    if(return_code != CURLE_OK){
        fprintf(stderr,"init libcurl failed!\n");
        return -1;
    }
    CURL *easy_handle = curl_easy_init();
    if(easy_handle == NULL){
        fprintf(stderr,"get a easy handle failed!\n");
        curl_global_cleanup();
    }
    char *progress_data = "* ";
    FILE *fp = fopen("OS3Beta.tar.xz","ab+");
    curl_easy_setopt(easy_handle,CURLOPT_URL,"http://mirrors.ustc.edu.cn/anthon/os3-releases/01_Beta/01_Tarballs/aosc-os3_mate-beta_pichu_dpkg_en-US.tar.xz");
    curl_easy_setopt(easy_handle, CURLOPT_NOPROGRESS, 0);
    curl_easy_setopt(easy_handle, CURLOPT_PROGRESSDATA,progress_data);
    curl_easy_setopt(easy_handle, CURLOPT_PROGRESSFUNCTION, progress_func);
    curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &write_data);
    curl_easy_setopt(easy_handle, CURLOPT_WRITEDATA, fp);

    curl_easy_perform(easy_handle);
    curl_easy_cleanup(easy_handle);
    curl_global_cleanup();
    return 0;
}


