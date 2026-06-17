# Session 58 — iter-058 review

## Metadata

- **Archon iteration**: 058
- **Stage**: prover (Phase A step 6 *Path 2* / Serre-finiteness scaffolding — **n-ary basic-open intersection inclusion helper**)
- **File touched**: `AlgebraicJacobian/Cohomology/MayerVietoris.lean` (single file, single Edit)
- **Sorry count before**: 9 (5 protected `Jacobian.lean` + 3 protected `AbelJacobi.lean` + 1 deferred `Picard/Functor.lean`)
- **Sorry count after**: 9 (unchanged — body probe-confirmed; no transient scaffold sorries)
- **LOC delta on touched file**: 1548 → 1584 (+36, squarely inside the tighter `+30-50` plan band and inside the wider `+30-50` iteration-overview band per the iter-058 prompt header). Function body is 2 LOC of actual proof; remaining +34 LOC is the verbatim long docstring.
- **Attempts (raw events from `attempts_raw.jsonl`)**: **1 substantive Edit** (single append between iter-057's `basicOpenCover_finset_inf'_isAffineOpen` (ending L1544) and the closing `end CoverTotality`), 1 diagnostic check (clean), 1 axiom verification (kernel-only on the new declaration), 0 builds, 0 lemma searches, **0 corrective Edits — twelfth zero-corrective single-Edit iteration in a row** (iter-047 → iter-048 → iter-049 → iter-050 → iter-051 → iter-052 → iter-053 → iter-054 → iter-055 → iter-056 → iter-057 → iter-058).
- **Net diagnostics (review-side captured from `attempts_raw.jsonl` line 5)**: clean — `lean_diagnostic_messages` returns `{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}`.
- **Axioms (this pass, review-side captured from `attempts_raw.jsonl` line 6)**: kernel-only `[propext, Classical.choice, Quot.sound]` on the new declaration, verified via `lean_verify` directly during the prover session. The pre-existing `local instance` warning at L259 is iter-020 scaffolding, not new. No new axiom introduced.

## Target attempted (one solved, single Edit)

The plan: append a single thin foundational inclusion helper to `Cohomology/MayerVietoris.lean` `section CoverTotality` (inside `namespace AlgebraicGeometry.Scheme`), after iter-057's `basicOpenCover_finset_inf'_isAffineOpen` (L1539-1544), before `end CoverTotality`. The helper supplies the `V ≤ U` inclusion morphism needed for the iter-059+ Mathlib `IsAffineOpen.isLocalization_of_eq_basicOpen` call site.

### Target — `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le` (L1574-1580)

`theorem`. N-ary intersection of basic-open cover members over a non-empty `Finset s` is contained in `U`. Term-mode body chains iter-057's `basicOpenCover_finset_inf'_eq_basicOpen_prod` with Mathlib's `Scheme.basicOpen_le` via `▸`-rewrite. **No `IsAffineOpen U` hypothesis required** — `basicOpen_le` holds for any open `U` (compare iter-057's `basicOpenCover_finset_inf'_isAffineOpen` which does need `(hU : IsAffineOpen U)`).

#### Attempt 1 (success — first attempt, single Edit)
- **Strategy**: Verbatim probe-confirmed body from PROGRESS.md template. Term-mode `▸` (Eq.mpr) chains iter-057's identification with Mathlib's `Scheme.basicOpen_le`. The body is a two-line term: `basicOpenCover_finset_inf'_eq_basicOpen_prod s t h ▸ C.left.basicOpen_le _`.
- **Code applied** (signature + body, L1574-1580):
  ```lean
  theorem basicOpenCover_finset_inf'_le
      {k : Type u} [Field k] {C : Over (Spec (.of k))}
      {U : TopologicalSpace.Opens C.left.toTopCat}
      (s : Set Γ(C.left, U)) (t : Finset s) (h : t.Nonempty) :
      t.inf' h (basicOpenCover (C := C) (U := U) s) ≤ U :=
    basicOpenCover_finset_inf'_eq_basicOpen_prod s t h ▸
      C.left.basicOpen_le _
  ```
- **Diagnostic check**: `lean_diagnostic_messages` returned `{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}` (file-level, `attempts_raw.jsonl` line 5).
- **Axiom check**: `lean_verify AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le` returned `{axioms: ["propext", "Classical.choice", "Quot.sound"], warnings: [{line: 259, pattern: "local instance"}]}` (`attempts_raw.jsonl` line 6). Kernel-only — the L259 `local instance` warning is pre-existing iter-020 scaffolding, not new.
- **Insight**: Term-mode `▸` rather than tactic-mode `rw` is mandatory for the same reason iter-057's `basicOpenCover_finset_inf'_isAffineOpen` needed it — implicit `Subtype.val` coercions on elements of `Finset s` cause motive-occurrence issues with `rw`. The body mirrors iter-057 Target 2's shape exactly: one-line term using the previous identification + `▸` + the appropriate single-argument Mathlib downstream lemma (`hU.basicOpen _` for iter-057 Target 2, `C.left.basicOpen_le _` for iter-058). The `(C := C) (U := U)` implicit annotation on the `basicOpenCover` reference matches the iter-054/056/057 convention. **No new imports required** — `Scheme.basicOpen_le` is already transitively in scope through Mathlib's `AlgebraicGeometry.OpenImmersion` (no Edit to the import header was made).

## Key findings / proof patterns

- **`▸`-rewrite chain pattern for inclusion-style helpers** *(iter-058, confirmed and reusable)*: when chaining a project-local equation `LHS = RHS_in_single_basic_open_form` with a Mathlib single-argument downstream lemma (`basicOpen_le _`, `hU.basicOpen _`, etc.), the term-mode body `<eq_lemma> ▸ <downstream_call>` is the canonical shape. Reused verbatim from iter-057 Target 2 to iter-058. Generalises further: any time the project-local rewrite produces a `Subtype.val`-coerced LHS, term-mode `▸` (Eq.mpr) is mandatory; tactic-mode `rw` fails on motive-occurrence grounds.
- **No-`IsAffineOpen`-hypothesis variant** *(iter-058)*: `Scheme.basicOpen_le` does not require affine-openness of `U`. This is a structural property of basic opens: `X.basicOpen f ≤ U` holds for any `f : Γ(X, U)`. The iter-058 declaration drops the `(hU : IsAffineOpen U)` argument compared with iter-057 Target 2 — a strictly weaker hypothesis variant of the n-ary intersection-on-affine helpers cohort. Reusable: future inclusion-only helpers should not over-quantify with `IsAffineOpen` if the downstream Mathlib lemma is purely topological.
- **Cleanest LOC-band-conforming iteration in the iter-053 → iter-058 chain** *(iter-058)*: +36 LOC, body is 2 LOC of actual proof + ~28 LOC verbatim docstring + 6 LOC signature. The iter-054 → iter-057 chain came in at +52/+45/+38/+71; iter-058 is the smallest. Function-body alone is the smallest substantive contribution in the chain (iter-054 had 9 LOC of body, iter-055 had 7+1=8, iter-056 had 2+3=5, iter-057 had 8+1=9, iter-058 has 2 — sub-linear in cumulative scaffolding).
- **Verbatim probe-confirmed body, single combined Edit pattern continues** *(iter-035 → iter-058)*: 21 of 24 iterations zero-corrective-Edit, 1 with cosmetic corrective (iter-044), 1 with cosmetic corrective (iter-046). **Iter-058 = twelfth zero-corrective Edit in a row** (iter-047 → iter-058). Pattern firmly established across the entire iter-053 → iter-058 six-iteration scaffolding chain.
- **Foundational scaffolding decomposition closes (six iterations deep)** *(iter-053 → iter-058)*: the scaffolding chain is now six iterations deep, all single-Edit zero-corrective. iter-053 introduced the existence-bundled carrier; iter-054 introduced the basic-open cover constructor + supremum-equality + single-index affine; iter-055 introduced the existence-form producer + curve specialisation; iter-056 introduced the binary-intersection identification + affine-intersection transport; iter-057 introduced the n-ary `Finset.inf'` identification + n-ary affine-intersection transport; iter-058 (this iteration) closes the chain with the n-ary inclusion-in-`U` helper. Iter-059+ moves to the substantive basic-open Koszul acyclicity branch.

## Blueprint markers updated

The iter-058 plan-agent **continued the blueprint-subsection / `\leanok`-pre-mark discipline** that iter-051 → iter-057 sustained. The plan-agent authored:

1. **The iter-058 subsection** at L1370-L1395 of `Cohomology_MayerVietoris.tex` (`\subsection{N-ary basic-open intersection inclusion (iter-058)}`) with one block:
   - `\begin{theorem}\leanok` block (`thm:Scheme_basicOpenCover_finset_inf_le`, statement `\leanok` at L1382) + `\begin{proof}\leanok` block at L1393.
   The `\uses{def:Scheme_basicOpenCover, thm:Scheme_basicOpenCover_finset_inf_eq_basicOpen_prod}` cross-references all resolve correctly (iter-054 + iter-057 anchors).
2. **The informal scoping subsection** retitled to `\subsection{Toward the iter-059+ comparison theorem (informal scoping)}` at L1397 (one step forward from iter-057's L1370 placement; iter-058's inclusion helper referenced in the iter-059+ Koszul-step description at L1415).
3. **The retrospective paragraph at L1422 ("Use in Serre finiteness")** was extended to reference the iter-058 label — `\ref{thm:Scheme_basicOpenCover_finset_inf_le}` — now resolving correctly.
4. **`blueprint/lean_decls`** caught up with 1 new entry at L114 (`basicOpenCover_finset_inf'_le`). **Nineteenth clear-as-you-go iteration in a row** for `lean_decls` (iter-040 → iter-058).

This review-side pass:
- Re-verified the iter-058 declaration exists at the name referenced by `\lean{...}`:
  - `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le` at L1574.
- Re-verified the file compiles cleanly via `attempts_raw.jsonl` line 5 (`{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}`).
- Re-verified the declaration carries kernel-only axioms via `attempts_raw.jsonl` line 6 (`{"axioms": ["propext", "Classical.choice", "Quot.sound"], "warnings": [{"line": 259, "pattern": "local instance"}]}`).
- No new `% NOTE:` comments needed in `Cohomology_MayerVietoris.tex` (existing `% NOTE:` comments in `Picard_FunctorAb.tex` / `Picard_LineBundle.tex` / `Rigidity.tex` are historical and untouched).
- No `\notready` markers remain in any chapter (verified absent via Grep across `blueprint/src/chapters/`).
- **No new marker changes from the review side this pass — the plan-agent's pre-marks are all valid.**

### Marker change record

- `Cohomology_MayerVietoris.tex`, **iter-058 subsection** (newly authored by the plan-agent this iteration at L1370-L1395): pre-marks validated.
  - `thm:Scheme_basicOpenCover_finset_inf_le` `\leanok` on statement at L1382 + proof at L1393.
  - **Iter-058 declaration correspondingly compiles, `sorry`-free, with kernel-only axioms (verified this pass via `attempts_raw.jsonl`).**
- `Cohomology_MayerVietoris.tex`, **retrospective "Use in Serre finiteness" paragraph** at L1422: extended to reference the iter-058 label — label resolves correctly.
- `Cohomology_MayerVietoris.tex`, **informal scoping subsection retitled** at L1397: `Toward the iter-059+ comparison theorem` (correctly renumbered from `iter-058+`).

## Recommendations for next session (iter-059)

See `recommendations.md`. With iter-058's n-ary inclusion-in-`U` helper landing, the iter-053 → iter-058 scaffolding chain is **complete** at six iterations deep. Any iter-059+ work constructing per-affine basic-open `IsCechAcyclicCover` + `HasCechToHModuleIso` evidence can now use the full toolkit:
- `basicOpenCover s` for the cover family (iter-054),
- `basicOpenCover_supr_of_span_eq_top` for the supremum equality (iter-054),
- `basicOpenCover_isAffineOpen` for single-index affine membership (iter-054),
- `basicOpenCover_inter_eq_basicOpen_mul` for binary-intersection identification (iter-056),
- `basicOpenCover_inter_isAffineOpen` for binary-intersection affine membership (iter-056),
- `basicOpenCover_finset_inf'_eq_basicOpen_prod` for n-ary intersection identification (iter-057),
- `basicOpenCover_finset_inf'_isAffineOpen` for n-ary intersection affine membership (iter-057),
- `basicOpenCover_finset_inf'_le` for n-ary intersection-in-`U` inclusion (iter-058, this iteration),
- `hasAffineCechAcyclicCover_of_basicOpen_curve h` for the producer call (iter-055),

with iter-053's producer instance firing automatically to derive `IsAffineHModuleVanishing`.

Iter-059+ work focuses on **the substantive Koszul + Čech-derived comparison branch** — basic-open Koszul acyclicity (~2-3 iter, ~150-250 LOC) → Čech-vs-derived comparison theorem (~4-6 iter, ~200-400 LOC) → final packaging (~1 iter) → genus carrier assembly (~1 iter). Phase A iterations-remaining now at ~5. **Iter-059 plan-agent should commission an analogy subagent first** to scope Mathlib's existing Koszul / Localization-exactness machinery (`exact_of_isLocalized_span`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `cechComplexFunctor`) before attempting the substantive Koszul iteration. The 8x cost differential between Mathlib-backed wrapper (~10-20 LOC) and project-local introduction (~80-150 LOC) warrants the upfront audit (strongly recommended preamble per the iter-058 prompt header — fifth-iteration repeat recommendation).
