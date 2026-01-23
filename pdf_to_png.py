#!/home/ayden/miniconda3/bin/python3
import os, argparse
from concurrent.futures import ProcessPoolExecutor, as_completed
from pdf2image import convert_from_path
from pdf2image.pdf2image import pdfinfo_from_path

def pdf_already_converted(pdf_path, output_dir, base_name):
    total_pages = pdfinfo_from_path(pdf_path)["Pages"]
    for p in range(1, total_pages + 1):
        if not os.path.exists(os.path.join(output_dir, f"{base_name}_page_{p}.png")):
            return False
    return True

def convert_one(pdf_path, output_dir, dpi):
    base_name = os.path.splitext(os.path.basename(pdf_path))[0]

    if pdf_already_converted(pdf_path, output_dir, base_name):
        return (os.path.basename(pdf_path), "skipped")

    pages = convert_from_path(pdf_path, dpi=dpi, thread_count=2)  # see #3
    for i, page in enumerate(pages, start=1):
        out = os.path.join(output_dir, f"{base_name}_page_{i}.png")
        page.save(out, "PNG")
    return (os.path.basename(pdf_path), f"done ({len(pages)} pages)")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-i","--input", required=True)
    ap.add_argument("-o","--output", required=True)
    ap.add_argument("--dpi", type=int, default=200)
    ap.add_argument("--workers", type=int, default=os.cpu_count() or 4)
    args = ap.parse_args()

    os.makedirs(args.output, exist_ok=True)

    pdfs = [os.path.join(args.input, f) for f in os.listdir(args.input) if f.lower().endswith(".pdf")]
    total = len(pdfs)
    if total == 0:
        print("No PDFs found.")
        return

    with ProcessPoolExecutor(max_workers=args.workers) as ex:
        futures = {ex.submit(convert_one, p, args.output, args.dpi): p for p in pdfs}
        done = 0
        for fut in as_completed(futures):
            done += 1
            name, status = fut.result()
            print(f"[{done}/{total}] {name}: {status}")

if __name__ == "__main__":
    main()
