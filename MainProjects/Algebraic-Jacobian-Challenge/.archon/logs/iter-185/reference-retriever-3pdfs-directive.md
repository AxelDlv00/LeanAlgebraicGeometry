# Reference Retriever Directive

## Slug
3pdfs

## Topic
Register **three locally-present PDFs** that have no `references/<slug>.md` pointer card yet. **DO NOT download anything** — every PDF named below is already on disk in `references/`. Your job for this directive is the **register-only** flavour of your usual workflow: verify each file is on disk, rename one of them (see PDF #3 below), write the pointer `.md` card, append a single row per book to `references/summary.md`. This is a deliberate detour from your default download-then-register loop; the dispatcher has already done the downloading.

## What the dispatcher will use this for
- **Leinster** — Yoneda / representables / limits / colimits prose backs categorical pre-substrate the project leans on heavily (sheafification arguments, fibered-product universal properties, representability of relative-Picard / Quot). Useful to the planner whenever a chapter wants a textbook citation for an elementary category-theory step instead of inventing one or vague-handing.
- **Atiyah–Macdonald** — primary-decomposition (Ch. 8) and Krull-dimension (Ch. 11) prose backs codim-1 reasoning shared by `Albanese/CodimOneExtension.lean` and the Weil-divisor surface API. Lightweight companion to Matsumura when only an undergraduate-level statement is needed.
- **Matsumura** — direct dependency of two **active** project files: `Albanese/AuslanderBuchsbaum.lean` (depth, regular sequences — Ch. 16–17; Auslander–Buchsbaum formula — Ch. 19) and `Albanese/CodimOneExtension.lean` (regular-local-ring / Krull-dim conjunction — Ch. 19). Matsumura's Ch. 16–19 chapters are the strongest open canonical reference for these statements; the blueprint chapters already cite them indirectly and a local copy lets the planner / writer quote verbatim instead of paraphrasing.

## PDFs to register

### (1) Leinster, "Basic Category Theory"
- **Local file (already present):** `references/leinster-basic-category-theory.pdf` — verify it exists, then proceed to write a pointer card.
- **Citation:** Tom Leinster, *Basic Category Theory*, Cambridge Studies in Advanced Mathematics 143, Cambridge University Press, 2014. Open-access edition: arXiv:1612.09375. (No download needed; the file is on disk.)
- **Slug:** `leinster-basic-category-theory`
- **Pointer card requirements:**
  - Contents map at **medium** depth: top-level chapters listed; **flag Ch. 4 (Yoneda / representables) and Ch. 5 (limits / colimits)** with the dispatcher's `← directive item` marker as the chapters this directive cares about.
  - Quote nothing from the source body — the contents map is a section / page index, not a paraphrase.
  - Note in the "Quality / provenance" line that this is the author-supplied arXiv edition equivalent to the CUP printed book.

### (2) Atiyah & Macdonald, "Introduction to Commutative Algebra"
- **Local file (already present):** `references/atiyah-macdonald-commutative-algebra.pdf` — verify it exists, then proceed to write a pointer card.
- **Citation:** M. F. Atiyah and I. G. Macdonald, *Introduction to Commutative Algebra*, Addison-Wesley, 1969.
- **Slug:** `atiyah-macdonald-commutative-algebra`
- **Pointer card requirements:**
  - Contents map at **medium** depth: chapter list; **flag Ch. 8 (primary decomposition) and Ch. 11 (Krull dimension)** with the `← directive item` marker.
  - Quote nothing; section / page numbers only.

### (3) Matsumura, "Commutative Ring Theory" — **REQUIRES RENAME FIRST**
- **Local file (already present, but with a non-ASCII character in its filename):** the PDF on disk is named `references/Matsumura-CommutativeRingTheory.pdf` per the user's hint, BUT the actual on-disk filename contains a stray box-drawing character before the `.pdf` extension. The real name on disk is roughly `matsumura-commutative-ring-theory │.pdf` (the `│` is U+2502 BOX DRAWINGS LIGHT VERTICAL — a single character, not a pipe).
- **Step 1 (RENAME the file):** rename the actual on-disk file to `references/matsumura-commutative-ring-theory.pdf`. Use a shell glob or `ls -1 references/ | grep -i matsumura` to discover the real current name, then `mv` it to the canonical kebab-case name. Verify with `ls -l references/matsumura-commutative-ring-theory.pdf` and `file references/matsumura-commutative-ring-theory.pdf` (expect "PDF document") before writing the pointer card.
- **Citation:** Hideyuki Matsumura, *Commutative Ring Theory*, Cambridge Studies in Advanced Mathematics 8, Cambridge University Press, 1987. (Translation by M. Reid of the Japanese original; revised English edition.)
- **Slug:** `matsumura-commutative-ring-theory`
- **Pointer card requirements:**
  - Contents map at **medium** depth: chapter list; **flag Ch. 16–17 (depth, regular sequences) and Ch. 18–19 (Auslander–Buchsbaum formula, projective dimension)** with the `← directive item` marker. These are the chapters that back `Albanese/AuslanderBuchsbaum.lean` and `Albanese/CodimOneExtension.lean`.
  - Quote nothing; section / page numbers only.
  - Record in the "Caveats" line that the file was renamed from a non-ASCII-character filename (`matsumura-commutative-ring-theory │.pdf` → `matsumura-commutative-ring-theory.pdf`) so a future agent doesn't get confused by the rename event.

## Seeds (NOT for downloading — for reference only)
- Leinster, arXiv:1612.09375 (CUP open-access edition equivalent to the printed book)
- Atiyah–Macdonald, no arXiv preprint; standard 1969 Addison-Wesley book
- Matsumura, CUP Cambridge Studies 8, 1987 (Reid translation)

Again: **do NOT download.** The three PDFs are already on disk. Your only network/filesystem work is the Matsumura rename in step (3). Everything else is pointer-card authoring + summary.md registration.

## Out of scope
- Do not download any of these PDFs from the web. Files already present.
- Do not paraphrase chapter content into the pointer cards. Section / page locations only.
- Do not delete or modify the existing entries in `references/summary.md`; append three new rows (one per book).
- Do not write outside `references/`.

## Contents-map depth expected
medium — chapter list per book, with the directive-flagged chapters marked. No theorem-level deep map; the planner / writer will jump to the flagged chapters directly when they need to quote.

## Verification before reporting
- `ls -l references/leinster-basic-category-theory.pdf references/atiyah-macdonald-commutative-algebra.pdf references/matsumura-commutative-ring-theory.pdf` — all three exist after your rename step.
- `file references/<each>.pdf` — all report "PDF document".
- `cat references/<each>.md` — each pointer card is on disk and follows the success-case template from your descriptor.
- `grep -c leinster\|atiyah\|matsumura references/summary.md` — three new rows appended (one per book).

Report in the standard format to `.archon/task_results/reference-retriever-3pdfs.md`.
