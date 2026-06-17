# AlgebraicJacobian/Picard/FlatteningStratification.lean — iter-055 (GF critical path)

## Summary

**Sorry count: 2 → 1.**

- **CLOSED `gf_common_basicOpen_basis`** (was L2912, the cross-chart realisation crux flagged
  STUCK for 2 iters) — axiom-clean.
- **`genericFlatness`** (L3032) — NOT fully closed, but reduced from a **bare** `sorry` to a
  **single precisely-isolated** `sorry` with all surrounding infrastructure built and the witness
  `V` constructed honestly. The one remaining gap is genuinely-missing Mathlib infrastructure.

New axiom-clean helpers built this iter (all verified `propext/Classical.choice/Quot.sound` only):
- `gf_section_span_flat_descent` — span-descent core (`Module.flat_of_isLocalized_span`).
- `gf_flat_of_isBaseChange_id` — per-piece base descent (one-line `Module.Flat.isBaseChange`
  consumer of the missing ingredient).

Adjacent sorries attempted beyond the assigned two: none exist (file had exactly 2).

## `gf_common_basicOpen_basis` (RESOLVED)

### Attempt 1 — Mathlib `exists_basicOpen_le_affine_inter`
- **Approach:** The in-code recipe (manual `b`,`g`,`IsLocalization.surj''`, `basicOpen_mul`) is
  *exactly* `Mathlib.AlgebraicGeometry.AffineScheme.exists_basicOpen_le_affine_inter`
  (`basicOpen_basicOpen_is_basicOpen` under the hood). Replaced the whole manual construction with
  one call: at `x ∈ W ⊓ Wi`, it returns `g ∈ Γ(X,W)`, `ḡ ∈ Γ(X,Wi)` with `D g = D ḡ` and `x ∈ D g`.
  `D g ≤ W ⊓ Wi` / `D ḡ ≤ W ⊓ Wi` follow from `X.basicOpen_le` on each chart + the common-open
  equality.
- **Result:** RESOLVED, axiom-clean.
- **Key insight:** the cross-chart realisation IS packaged in Mathlib — no manual localization
  surjectivity needed. `exists_basicOpen_le_affine_inter hU hV x hx`.

## `genericFlatness` (PARTIAL — 1 isolated sorry; the gap is missing Mathlib infra)

### What is now built (axiom-clean, compiles, `lake build` green in 100s)
1. **Witness `V = D(∏ⱼ fⱼ)` constructed honestly.** Cover scaffold:
   - `p.isCompact_preimage hU₀aff.isCompact` + `isCompact_iff_finite_and_eq_biUnion_affineOpens`
     → finite affine cover `{↑i}_{i∈s}` of `p⁻¹(U₀)`.
   - per-patch: `Algebra A Γ(X,↑i)` via `p.appLE`, `Algebra.FiniteType` via `p.finiteType_appLE`,
     `Module.Finite Γ(X,↑i) Γ(F,↑i)` via `gf_qcoh_fintype_finite_sections`, A-module via
     `Module.compHom`, tower via `of_algebraMap_smul rfl` → `genericFlatnessAlgebraic` → `fᵢ ≠ 0`.
   - `choose!`, `f := ∏ i ∈ sf, f0 i`, `hf_ne` via `Finset.prod_ne_zero_iff` (domain `A`).
   - `V := S.basicOpen f`, non-empty via `basicOpen_eq_bot_iff` (`S` integral ⟹ reduced).
2. **Per-`(U,W)` flatness reduced** via `gf_section_span_flat_descent p F hW e t ht_span` +
   `gf_crossChart_spanning_cover` (patch-aligned spanning cover; `hWcov` from
   `(Opens.map p.base).monotone` + `hs_eq` + `iSup_subtype'`) to the **per-piece**
   `Module.Flat Γ(S,U) Γ(F, X.basicOpen g)`.

### The single remaining `sorry` — genuinely missing Mathlib ingredient
The per-piece flatness, after the documented chain (B2.1 `D g = D ḡ` → B2.2 leg2 `(Mᵢ)_ḡ` →
patch freeness → `A_f`-flatness → B1 source-localise), needs
**`IsBaseChange Γ(S,U) (id : M →ₗ[Γ(S,V)] M)`** to feed `gf_flat_of_isBaseChange_id`, i.e. that the
open immersion `U ↪ V` makes `Γ(S,V) → Γ(S,U)` a **flat ring epimorphism** (`R ⊗_{A_f} R ≅ R`).
- Searched: `Module.Flat.of_isLocalizedModule`, `flat_iff_of_isLocalization`,
  `Module.Flat.isBaseChange`, `RingHom.Flat`, `IsOpenImmersion` API. **None** supply the
  flat-epimorphism / open-immersion base-change at the module level.
- B2.3 (`gf_base_localization_comparison`) only gives `Γ(S,U)` *flat* over `Γ(S,V)`; an arbitrary
  affine `U ≤ V` need not be a *basic* open, so `Γ(S,U)` is not a *localization* of `Γ(S,V)` —
  the localization-descent lemmas do not apply. **This is the real gap.**
- Full precise statement + cleanest `mathlib-build` factoring written to
  `informal/gf_openImmersion_isBaseChange.md`.
- **No LLM key in env** (confirmed via PROGRESS standing note) — informal agent unavailable;
  used blueprint + Mathlib search + manual analysis.

### Counterexample check (why the gap is real, not laziness)
"`M` flat over `A_f` + tower `A_f → R → M` ⟹ `M` flat over `R`" is **FALSE** in general
(`A_f = k`, `R = k[x]`, `M = k[x]/(x)`). It becomes true precisely because `A_f → R` is a flat
*epimorphism* (open immersion mono) — exactly the missing fact.

## Blueprint markers
- `lem:gf_common_basicOpen_basis` proof block → ready for `\leanok` (sync phase).
- New decls `gf_section_span_flat_descent`, `gf_flat_of_isBaseChange_id` are project-local; planner
  may add `\lean{}` hints (`lem:gf_section_span_flat_descent`, `lem:gf_flat_of_isBaseChange_id`) —
  they replace the never-built `gf_section_localization_flat_descent` / B2.3-as-localization in the
  assembly chain. `thm:generic_flatness` stays unmarked (1 sorry).

## Why I stopped — `Partial progress` (strong)
- **Real progress:** closed 1 sorry (`gf_common_basicOpen_basis`) + built 2 new axiom-clean
  lemmas + converted `genericFlatness`'s bare sorry into a constructed witness `V` + a full cover
  scaffold + a span-descent reduction to a single isolated per-piece sorry. Sorry count 2 → 1.
  `lake build` GREEN.
- **Specific remaining blocker:** the per-piece flatness needs the open-immersion flat-epimorphism
  base change `IsBaseChange Γ(S,U) (id : M →ₗ[Γ(S,V)] M)`, which is **absent from Mathlib** (the
  localization-only descent lemmas do not cover non-basic affine `U ≤ V`). The consumer lemma
  `gf_flat_of_isBaseChange_id` is already built and waiting for this hypothesis; precise handoff in
  `informal/gf_openImmersion_isBaseChange.md`.
- Per progress-critic STUCK contingency: `genericFlatness` did not fully close → planner should
  escalate the **open-immersion base-change** sub-lemma to a `mathlib-build` lane (NOT re-queue an
  identical prover round). All the geometric/algebraic plumbing is now done; only that one
  ring/module-theory lemma remains.
