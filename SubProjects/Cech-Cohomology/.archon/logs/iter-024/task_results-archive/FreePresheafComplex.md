# AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

## Session summary (iter-023, prover, mathlib-build)

**THE iter-023 bottleneck is RESOLVED.** `cechFreeEvalEngineIso` — the differential
comm-square / variance match that CHURNED for 3 iterations — is built and **axiom-clean**
(`{propext, Classical.choice, Quot.sound}`). Plus the full supporting chain and a bonus
engine-acyclicity lemma.

- sorry count in file: **0 → 0** (file was already 0-sorry; everything added is fully proved).
- Build: GREEN (LSP `success: true`, no errors, no warnings except the pre-existing module-doc note).

### Declarations added (14, all axiom-clean)

Engine-augmentation pieces toward (2) (all axiom-clean, landed this session):
- `cechEngineAug0` (def) — codiagonal `∐_{Fin 1→I₁} O_X(V) ⟶ O_X(V)`.
- `cechEngineAug0_ι` (lemma) — `ι_σ ≫ aug = 𝟙`.
- `cechEngineD_comp_aug` (lemma) — `cechEngineD 0 ≫ cechEngineAug0 = 0` (chain-map condition).
- `cechEngineComplexAug` (def) — the engine augmentation chain map `cechEngineComplex ⟶ O_X(V)[0]`.

These reduce (2) to: prove `QuasiIso (cechEngineComplexAug 𝒰 V)` (positive degrees from
`cechEngineComplex_exactAt`; degree 0 from `cechEnginePrepend_spec`/`cechEngineD_exact` at `n=0` +
`ChainComplex.toSingle₀Equiv` giving `H₀ ≅ O_X(V)`), then transfer across `cechFreeEvalEngineIso` +
the degree-0 identification `(eval V).obj(coverStructurePresheaf 𝒰) ≅ O_X(V)` (nonempty) via
`quasiIso_of_arrow_mk_iso`.

### Core declarations added (10, all axiom-clean)

Non-private (need blueprint entries — see below):
1. `freeYonedaEval_iso_of_le_hom_eq_aug` (line ~975) — bridge: `(freeYonedaEval_iso_of_le h).hom = (freeYonedaAug W).app (op V)`.
2. `freeYonedaEval_iso_of_le_natural` (line ~990) — naturality of the per-summand identification.
3. `cechFreeEvalEngineIso` (line ~1136, **the named (1) target**) — the chain iso
   `((eval (op V)).mapHomologicalComplex (.down ℕ)).obj (cechFreePresheafComplex 𝒰) ≅ cechEngineComplex 𝒰 V`.
4. `cechEngineComplex_exactAt` (line ~1162) — positive-degree exactness of the engine complex (nonempty case).

Private helpers (fold into a related decl's `\lean{...}` list so `unmatched` stays 0):
5. `cechFreeEval_X_ι_inv` — `PreservesCoproduct.iso` ι-rule for `cechFreeEval_X`.
6. `cechFreeEvalEngine_X_inv_hom_ι` — reduced action of the engine id on a surviving injection (RHS uses the **iso** `(freeYonedaEval_iso_of_le hσ).hom`, NOT the aug — see dead-end note).
7. `cechFreeEvalEngine_map_ι` — action of the engine id on an *evaluated* injection.
8. `freeYonedaAug_app_comp` — `.app`-level form of `freeYoneda_map_comp_aug`.
9. `cechFree_d_ι` — free Čech differential on a coproduct injection = `∑ i (-1)^i • (restriction ≫ ι_{σ∘succAbove i})`.
10. `cechFreeEvalEngine_comm` — **the differential comm-square** (the 3-iter bottleneck core).

## Why I stopped
**Real progress: 10 axiom-clean declarations**, culminating in `cechFreeEvalEngineIso` (named
target (1), DONE) and the bonus `cechEngineComplex_exactAt`. The remaining named targets
(2) `cechFreeEval_quasiIso_of_nonempty` and (3) `cechFreeComplex_quasiIso` are a *separate*
construction (engine augmentation + H₀ identification + Arrow-iso transfer) — all their
prerequisites are now in place. Stopped here as a clean axiom-clean boundary; (2)/(3) are
all-or-nothing `def`/`lemma`s that cannot be partially landed with a sorry.

## KEY TECHNIQUE that unlocked the bottleneck (read before continuing)
The free Čech complex is built via `cechFreeSimplicial`/`alternatingFaceMapComplex`, whose objects
carry the index `Fin ((unop ⦋p+1⦌).len + 1)` and degrees `p+2` vs `p+1+1` that are **defeq but NOT
syntactically equal** to the `Fin (p+1+1)` forms produced by `cechFreeEval_X`/`cechEngineX`.
This makes `rw`/`slice`/`Category.assoc`/`Preadditive.comp_sum`/`Functor.map_comp` **fail
to match** even when the goal visually contains the pattern. The fixes, used throughout:
- **`erw [...]`** instead of `rw` — uses defeq matching (cracked `← Functor.map_comp`, `Category.assoc`,
  `Functor.map_sum`, `cechFree_d_ι`, `cechFreeEvalEngine_map_ι`).
- **`refine (lemma_term).trans ?_`** instead of `rw [lemma]` — `exact`/`refine` close up to defeq, so
  `Preadditive.comp_sum`/`comp_zsmul` go through where `rw`/`simp only` report "unused"/"not found"
  (this is how `cechFree_d_ι`'s sum distribution was proved).
- **`slice_lhs i j => rw [...]`** for grouping a sub-composition — works when the middle objects are
  clean; but slice CANNOT see through a defeq-mismatched `≫` (treats `aug ≫ ι` as one atom).
- **State the workhorse RHS with the clean-codomain form.** `cechFreeEvalEngine_X_inv_hom_ι` was
  first stated with `(freeYonedaAug W).app (op V)` (codomain `(eval).obj unit`), which is defeq —
  but NOT syntactically — `coverSectionModule V`, creating a defeq middle object in `aug ≫ Sigma.ι`
  that broke all downstream `slice`/`assoc`. **Switching its RHS to `(freeYonedaEval_iso_of_le hσ).hom`
  (codomain literally `coverSectionModule V`) fixed it** (and `congr 1` then closes it directly, since
  the bridge `freeYonedaEval_iso_of_le_hom_eq_aug` makes the iso proof-independent).

## Precise recipe for the remaining (2) + (3)

### (2) `cechFreeEval_quasiIso_of_nonempty (𝒰) [Finite 𝒰.I₀] (V : Opens X) (i_fix : {i // V ≤ coverOpen 𝒰 i})`
Target: `QuasiIso (((PresheafOfModules.evaluation _ (op V)).mapHomologicalComplex (.down ℕ)).map (cechFreeComplexAug 𝒰))`.
Route B (per `analogies/free-eval-engine-iso.md`):
- **Positive degrees `n+1`**: now trivial. Source homology ≅ `(cechEngineComplex).homology (n+1)` via
  `cechFreeEvalEngineIso` (use `HomologicalComplex.homologyMap` of the iso, or `quasiIso_of_arrow_mk_iso`),
  and `cechEngineComplex_exactAt 𝒰 V i_fix n` ⟹ `IsZero ((cechEngineComplex).homology (n+1))` via
  `HomologicalComplex.exactAt_iff_isZero_homology`. Target `(single₀).obj(...)` has 0 homology in deg ≥1.
- **Degree 0** (the real remaining work): build the engine augmentation
  `cechEngineComplex 𝒰 V ⟶ (single₀).obj (coverSectionModule V)` (degree-0 component = the desc of the
  per-`σ:Fin 1` `freeYonedaEval` ≅ `O_X(V)`, all equal; `d ≫ aug = 0` by the same `δ₀ = δ₁` argument as
  `cechFree_d_comp_aug`). Show H₀(engine) ≅ `O_X(V)` via `cechEngineD_exact`/`cechEnginePrepend_spec` at
  `n=0` + `ChainComplex.toSingle₀Equiv`. Then identify, in the nonempty case, `(eval V).obj(coverStructurePresheaf 𝒰) ≅ O_X(V)` (the image presheaf is everything since `V ≤ U_{i_fix}`),
  compatibly with `cechFreeComplexAug`. Assemble an `Arrow.mk` iso between
  `Arrow.mk ((eval).mapHC.map (cechFreeComplexAug))` and `Arrow.mk (engine augmentation)` from
  `cechFreeEvalEngineIso` (source) + the degree-0 target iso, then transfer via
  `quasiIso_of_arrow_mk_iso` / `HomologicalComplex.instRespectsIsoQuasiIso`.

### (3) `cechFreeComplex_quasiIso (𝒰) [Finite 𝒰.I₀]` (THE named target)
`QuasiIso (cechFreeComplexAug 𝒰)`. One-liner given (2):
```
apply quasiIso_of_evaluation   -- line ~414, already axiom-clean
intro V
by_cases h : ∃ i, V.unop ≤ coverOpen 𝒰 i
· obtain ⟨i, hi⟩ := h; exact cechFreeEval_quasiIso_of_nonempty 𝒰 V.unop ⟨i, hi⟩  -- (2)
· exact cechFreeEval_quasiIso_of_isEmpty 𝒰 V.unop (by push_neg at h; exact h)    -- DONE (line ~687)
```
(Watch the `op`/`unop`: `quasiIso_of_evaluation` quantifies `V : (Opens X)ᵒᵖ`; the empty/nonempty
helpers take `V : Opens X`.)

## Dead-end warnings (do NOT retry)
- `rw [Category.assoc]` / `rw [Preadditive.comp_sum]` / `rw [← Functor.map_comp]` / `simp only [comp_sum]`
  on the free-complex compositions: FAIL silently ("pattern not found" / "no progress" / "unused")
  because of the `unop.len`/`p+2`-vs-`p+1+1` defeq-not-syntactic middle objects. Use `erw` or
  `refine (term).trans ?_`.
- Stating `cechFreeEvalEngine_X_inv_hom_ι` with the `freeYonedaAug` form (codomain `(eval).obj unit`):
  breaks all downstream slicing. Keep the `(freeYonedaEval_iso_of_le hσ).hom` form.
- `HomologicalComplex.sc'_f` / `_obj_d` / `mapHomologicalComplex_obj_d` (HomologicalComplex namespace):
  do NOT exist. Use `Functor.mapHomologicalComplex_obj_d`; `sc'.f`/`.g` reduce by `change` to `K.d`.

## Needs blueprint entry (mandatory report — lean_aux nodes, currently `unmatched`)
The planner/reviewer must blueprint these (or bundle the privates into a related decl's `\lean{...}`):
- **`lem:cech_free_eval_engine_iso`** is NOW formalized by `cechFreeEvalEngineIso` (def) — add `\lean{...AlgebraicGeometry.cechFreeEvalEngineIso}` and `\leanok` will be set by sync.
  Its proof relies on: `cechFreeEvalEngine_comm` (comm-square), `cechFreeEvalEngine_X` (already built),
  `cechEngineComplex` (already built), `Functor.mapHomologicalComplex_obj_d`, `ChainComplex.of_d`.
- New non-private lemmas needing nodes/`\lean` bundling: `freeYonedaEval_iso_of_le_hom_eq_aug`,
  `freeYonedaEval_iso_of_le_natural`, `cechEngineComplex_exactAt` (this one is a new positive-degree
  acyclicity fact — candidate `lem:cech_engine_acyclic`, relies on `cechEngineD_exact` + `ModuleCat.shortComplex_exact` + `HomologicalComplex.exactAt_iff'`).
- New private helpers to bundle into a `\lean{...}` list (private does NOT exempt from `unmatched`):
  `cechFreeEval_X_ι_inv`, `cechFreeEvalEngine_X_inv_hom_ι`, `cechFreeEvalEngine_map_ι`,
  `freeYonedaAug_app_comp`, `cechFree_d_ι`, `cechFreeEvalEngine_comm`.

## Module-doc note (carried lean-auditor MAJOR, for reviewer)
The file header (lines ~21-23) still claims ownership of `cechFreeComplex_quasiIso`, which is NOT yet
built (only its prerequisites are). The header is now MORE accurate (`cechFreeEvalEngineIso` done) but
the `cechFreeComplex_quasiIso` claim should get a "(not yet built — see task_results)" qualifier until
(2)/(3) land.

## Decl-by-decl
- **cechFreeEvalEngineIso** — RESOLVED, axiom-clean. `isoOfComponents (cechFreeEvalEngine_X) comm`; comm
  for `Rel (p+1) p` (down ℕ `Rel i j ↔ j+1 = i`) via `Functor.mapHomologicalComplex_obj_d` + `ChainComplex.of_d` + `cechFreeEvalEngine_comm`.
- **cechFreeEvalEngine_comm** — RESOLVED. `cancel_epi (cechFreeEval_X (p+1)).inv` → `Sigma.hom_ext`;
  empty summand by `IsZero.eq_of_src`; surviving summand by `slice_lhs`/`erw` reduction of both sides to
  `(freeYonedaEval_iso_of_le hσ).hom ≫ ∑ i (-1)^i • ι_{lift∘succAbove i}` (LHS via `cechFreeEvalEngine_X_inv_hom_ι`
  + `cechEngineD_ι`; RHS via `cechFreeEval_X_ι_inv` + `cechFree_d_ι` + `Functor.map_sum` + per-summand
  `cechFreeEvalEngine_map_ι` + `freeYonedaEval_iso_of_le_natural`).
- **cechEngineComplex_exactAt** — RESOLVED. `exactAt_iff'` at `(n+2,n+1,n)` + `ModuleCat.shortComplex_exact`
  + `change`-to-`d`-form + `ChainComplex.of_d` + `cechEngineD_exact`.
- **cechFree_d_ι** — RESOLVED (the sum-distribution gremlin). `refine (Preadditive.comp_sum ...).trans ?_`
  (defeq), per-i `refine (Preadditive.comp_zsmul _ _ _).trans ?_`, `SimplicialObject.δ`/`cechFreeSimplicial`
  unfold + `Sigma.ι_desc` + `rfl` (coe_δ = succAbove defeq).
