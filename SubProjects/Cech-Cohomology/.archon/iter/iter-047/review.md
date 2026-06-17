# iter-047 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both frozen/superseded (`CechHigherDirectImage.lean:679`
  protected main theorem, `CechAcyclic.lean:110` dead `affine`). Prover file `QcohTildeSections.lean`
  is 0-sorry.
- **Build:** GREEN. `lake env lean` full project build 8332 jobs, exit 0 (only pre-existing style
  warnings). Review re-verified first-hand: `#print axioms` on `qcoh_section_isLocalizedModule` AND
  `qcoh_section_kernel_comparison` = `{propext, Classical.choice, Quot.sound}` (the stale-olean /
  LSP-accept≠kernel-accept discipline — these are real kernel verdicts).
- **Lanes planned 1, ran 1** (`mathlib-build`). **+6 axiom-clean decls, 0 new sorries. Named objective
  SOLVED and EXCEEDED** (keystone landed in the same lane).
- **dag-query:** gaps = 0, unmatched = 5 (1 pre-existing dead `CechAcyclic.affine` + 4 new this iter).
  `sync_leanok` ran iter-047 (sha `9d759ec`, +6/−2). **blueprint-doctor:** no structural findings.

## Headline — the Route B keystone `qcoh_section_isLocalizedModule` LANDED axiom-clean
This is the decisive milestone of the 01I8 route. After the 041→046 tile-lemma decomposition closed
its last leaf, iter-047 assembled the keystone itself: for quasi-coherent `F` on `Spec R` and `f ∈ R`,
`ρ_f : Γ(X,F) → Γ(D(f),F)` exhibits `Γ(D(f),F)` as the localization of `Γ(X,F)` at the powers of `f` —
the single load-bearing input of Route B. The objective `qcoh_section_kernel_comparison` is its
packaged-iso corollary, and a genuinely reusable abstract primitive `isLocalizedModule_of_exact` (the
converse of Mathlib's `IsLocalizedModule.map_exact`) fell out as a byproduct. The keystone has now
landed axiom-clean decls every prover iter on this route (040→047), with 047 closing the keystone.

## This iter's analysis
- **No forced mathematics; clean SOLVE.** The `mathlib-build` no-sorry invariant held; the named target
  closed fully and the keystone stretch landed too. Both were independently re-verified by review.
- **The obstruction was a single recurring wall — the `↑R`-Semiring instance diamond.** `basicOpen`
  pulls in `CommRingCat`'s CommRing→Semiring path while `ModuleCat.hom_comp`/`comp_apply`/`LinearMap.pi`
  lemmas use `Ring.toSemiring`; the two are defeq but not syntactic, so `rw`/`simp` silently fail to
  fire. The prover's resolution — `change`(defeq) for `LinearMap.pi` reductions, presheaf-abstracted
  helpers (`presheaf_map_comp₂_apply`, like `res_trans_apply`) applied via `refine (…).trans ?_`, and
  `@`-threaded instances rather than `haveI` — is the reusable recipe (now in the Knowledge Base). The
  decompositional discipline at each prior stage (blueprint expansion → mathlib-analogist consult →
  apply recipe → assemble) paid off: this final assembly was mechanical recipe-application, not new math.
- **Soundness independently confirmed, three ways.** (1) Review's own first-hand `lean_verify` on both
  headline decls. (2) lean-auditor `iter047`: 0 must-fix / 0 major; explicitly confirmed every
  `change` / `Subsingleton.elim` / `@`-thread is genuine, NOT the documented kernel-soundness trap
  (bare `ext`/`congr 1` auto-closing subsingleton goals with kernel-rejected rfl-terms); `maxHeartbeats`
  justified. (3) lean-vs-blueprint `qts`: both `\lean{}`-pinned statements match the blueprint, pins
  correct, no red flags.
- **One real DAG discrepancy, planner-domain, no soundness impact.** The Lean dependency direction is
  INVERTED from the blueprint: in Lean `qcoh_section_kernel_comparison := IsLocalizedModule.iso ρ_f`
  consumes the keystone, whereas the blueprint has `lem:qcoh_section_isLocalizedModule \uses
  lem:qcoh_section_kernel_comparison`. The keystone was built directly via `isLocalizedModule_of_exact`
  (which has no blueprint node). The checker confirms NO circularity (the chain is linear). I annotated
  both blocks with `% NOTE`s and flagged the `\uses`-flip + the missing `isLocalizedModule_of_exact`
  node for the planner (recommendations items 2–3).

## Markers / coverage
- **Manual marker edits (2 `% NOTE` additions):**
  - `lem:qcoh_section_isLocalizedModule` — replaced the stale `% NOTE: to-build` with a LANDED note
    (axiom-clean iter-047; built via `isLocalizedModule_of_exact`; records the inverted `\uses` edge).
  - `lem:qcoh_section_kernel_comparison` — added a `% NOTE` (Lean decl is the one-liner packaged-iso
    form; the equalizer-chase prose in this proof block actually describes the keystone's Lean proof;
    planner realign `\uses`).
  - No `\leanok` touched (sync owns it; +6 this iter, all genuine — verified). No `\mathlibok` (the new
    public decls are project theorems, not Mathlib re-exports). No `\lean{}` rename (both pins correct).
- **Coverage debt = 5 unmatched** (1 pre-existing dead + 4 new: `isLocalizedModule_of_exact` [needs a
  node — recs item 3] + 3 private helpers [bundle into `\lean{}` lists — recs item 5]). Listed for the
  planner in `recommendations.md`.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor `iter047`,
  lean-vs-blueprint-checker `qts`. Substantial new Lean this iter with nontrivial defeq/subsingleton
  closures warranted the soundness audit.)
