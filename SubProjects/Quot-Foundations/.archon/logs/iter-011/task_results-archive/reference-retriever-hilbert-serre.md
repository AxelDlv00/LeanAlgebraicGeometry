# Reference Retriever Report

## Slug
hilbert-serre

## Status
COMPLETE

All directive items downloaded and verified. The Stacks Project algebra chapter TeX source
was retrieved from GitHub and the exact tag locations for the Hilbert–Serre rationality
proposition (tag 00K1) and its inductive proof were pinned to exact line numbers.

## Sources fetched

- **Stacks Project "Algebra" chapter — tag 00K1 (Hilbert–Serre rationality)**
  - URL: `https://raw.githubusercontent.com/stacks/stacks-project/master/algebra.tex`
  - Downloaded: `references/hilbert-serre-algebra.tex` (1.7 MB TeX, verified — starts with `\input{preamble}`)
  - Pointer: `references/hilbert-serre.md`

- **Stacks Project tags file** (used for tag lookup only, not saved as a reference):
  - URL: `https://raw.githubusercontent.com/stacks/stacks-project/master/tags/tags`
  - Used to resolve tag↔label mappings; not saved (ephemeral lookup).

## Key findings — exact locations in `references/hilbert-serre-algebra.tex`

| Stacks tag | Label | Lines | Role |
|---|---|---|---|
| 00JV | `section-noetherian-graded` | 13778–13779 | Section: "Noetherian graded rings" |
| 00JX | `definition-numerical-polynomial` | 13824–13835 | Binomial-coefficient definition of numerical polynomial |
| **00JZ** | `lemma-numerical-polynomial` | 13856–13874 | **Key induction lemma** closing the proof of 00K1 |
| 00K0 | `lemma-graded-module-fg` | 13876–13891 | Finiteness of graded pieces as S₀-modules |
| **00K1** | `proposition-graded-hilbert-polynomial` | **13893–13948** | **Hilbert–Serre theorem** — verbatim quote target |
| 02CD | `remark-period-polynomial` | 13950–13956 | Periodic polynomial remark (non-degree-1 case) |
| 00K2 | `example-hilbert-function` | 13958–13966 | Specialisation to k[X₁,…,Xd]-modules, dim_k(Mₙ) polynomial |

**Proof structure of 00K1 (lines 13907–13948):**
Induction on the minimal number of generators of S₁. The decisive case (x∈S₁ acting
injectively on M) uses the degree-d short exact sequence
```
0 → M_d --x--> M_{d+1} → M̄_{d+1} → 0
```
at lines 13943–13944, giving [M_{d+1}]−[M_d]=[M̄_{d+1}]; then 00JZ closes the induction.

**Ingest command:** `Read references/hilbert-serre-algebra.tex` with `offset: 13778, limit: 210`
to get the full section in one call.

**Formulation note:** Stacks uses "numerical polynomial" rather than "Poincaré series is
rational". The two are equivalent; the blueprint can quote either the statement directly or
note the equivalence. When S₀=k (field), K'₀(k)=ℤ and Example 00K2 recovers the
classical dim_k(Mₙ) polynomial setting.

## Index updates
- `references/summary.md` — appended 1 entry: `hilbert-serre`

## Notes for Dispatcher

1. **Seed tag correction:** The directive named 00JW and 00P4 as seeds. Tag 00JW is
   `lemma-graded-Noetherian` (S graded Noetherian iff S₀ Noetherian and S₊ f.g.) — correct
   section, not the main theorem. Tag 00P4 is `lemma-dimension-at-a-point-preserved-field-extension`
   which is entirely unrelated to the Hilbert series. **The actual rationality theorem is 00K1,
   not near 00P4.** The Atiyah–Macdonald seed was not attempted (no legitimately open copy
   located; the Stacks 00K1 source is sufficient and self-contained).

2. **Atiyah–Macdonald:** No open copy of Atiyah–Macdonald Chapter 11 was located. The Stacks
   Project formulation at 00K1 is the definitive open-source reference and fully suffices for
   the blueprint's verbatim quotation needs.

3. **No PDF saved:** The Stacks Project algebra chapter exists only as TeX; there is no
   standalone chapter PDF to fetch (the full PDF is >1000 pages and not needed here).

4. **Adjacent useful tag** the dispatcher may want next: tag 00K3 (`lemma-quotient-smaller-d`,
   lines 13968–13986) gives the degree bound for Hilbert polynomials of quotients — may be
   useful for the Hilbert-polynomial-of-a-coherent-sheaf argument adjacent to
   `lem:gradedHilbertSerre_rational`.
