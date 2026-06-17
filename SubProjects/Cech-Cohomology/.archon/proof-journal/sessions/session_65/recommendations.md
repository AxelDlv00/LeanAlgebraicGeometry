# Recommendations for iter-066

## Headline state
- **Need#1 `higherDirectImage_openImmersion_acyclic` is CLOSED axiom-clean** — the open-immersion
  acyclicity route is DONE. No further prover work on it; do NOT re-dispatch.
- Project real sorry **12 → 9**. The four-iter plateau is broken; both the iter-064 decomposition
  AND this iter's closures vindicate the decompose-then-build corrective.

## Closest-to-completion / frontier-ready (prioritize)
1. **CSI Stub 5 `cechSection_complex_iso` (line 1418) + Stub 6 `cechSection_contractible` (line 1477).**
   Both now frontier-ready: Stub 5's dependency Stub 4 `pushPull_eval_prod_iso` is axiom-clean this
   iter. Blueprint detail is rated **adequate** by the lvb (Stub 5: `HomologicalComplex.mkIso` via
   `pushPull_eval_prod_iso` + `sectionCech_objD_apply` differential match, with a correctly-placed
   `Kp` type-adapter ambiguity flag; Stub 6: two-part structure — `depHomotopy` for degrees ≥1 +
   explicit `π_{i_fix}` augmentation node). These two close `CechAugmentedResolution.hSec`
   (line 229) downstream — a high-value chain. **Recommend single-leaf provers on both, paired.**

2. **OpenImm STRETCH `higherDirectImage_openImmersion_comp` (lines 942–985).** Decomposed into 4
   honest gaps. PLANNER DECISION REQUIRED — this is a stretch beyond the now-closed frozen target:
   - `hexact`, `transport`, `eRes` are mechanical (reuse `_acyclic` / `pushforwardComp` / finite-limit
     preservation of `pushforward j`).
   - **`hacyc` is the real gate: a genuinely NEW `f_*`-acyclicity vanishing result** (`R^{≥1} f_*(j_* Iⁿ)=0`),
     NOT an instance of `higherDirectImage_openImmersion_acyclic`. It needs its own lemma — same
     Serre-vanishing structure as Part (1) but with `G = pushforward f` and affine target opens pulled
     from `S`, not `X`. The blueprint under-specifies this (lvb minor). If pursued, **effort-break
     `hacyc` and write its blueprint node first** (do NOT bare-dispatch — the planner has learned this).

## Blueprint-writer tasks (HARD GATE inputs for next prover round)
The lvb checkers flagged must-fix BLUEPRINT items on the consolidated chapter
`Cohomology_CechHigherDirectImage.tex` (the review agent already fixed the 3 stale `% NOTE`s; the
following need a blueprint-WRITER, as they touch informal prose):
1. **(major) Rewrite the `lem:slice_reverse_ring_map` proof sketch** (chapter ~lines 10408–10444): it
   describes a 2-part codomain bridge that does NOT exist — the bridge is definitional. Replace with:
   "both `sheafPushforwardContinuousComp` and `Over.mapForget` are `rfl`, so φ'' is simply
   `sliceStructureSheafHom φ.symm Vᵢ` retyped along the (defeq) corrected-inverse codomain." This is
   the most important blueprint correction (a future prover would waste an iter rebuilding the bridge).
2. **(major) Split `higherDirectImage_openImmersion_acyclic` out of `lem:open_immersion_pushforward_comp`**
   into its own `\begin{lemma}` block. Right now the now-CLOSED acyclicity milestone is co-pinned with
   the still-open `_comp` STRETCH, so it can never get `\leanok` and the milestone is invisible in the
   DAG until the stretch closes. (This is a chapter-structure edit, not prose generation.)
3. **(minor) Strengthen the `hacyc` proof note** in `lem:open_immersion_pushforward_comp`: state
   explicitly that `f_*`-acyclicity of `j_* Iⁿ` is a NEW Lean declaration, not a reuse of `_acyclic`.

## Blocked / do-not-retry without structural change
- **CechHigherDirectImage:780 (frozen P5b)** — protected signature; do not touch.
- **CechAcyclic:110 (`affine`)** — dead end (the L1 section-complex bridge route the memory marks
  CIRCULAR). Recommend the planner consider deleting it (drops 1 sorry) unless a use remains.

## Tooling / infra (flag to planner + user)
- **`sync_leanok` under-marking** (see summary): iter=65 synced added=0/removed=0 despite multiple
  closures; lvb flags `pushPull_coprod_prod`, the three `private coprodToProd_isIso_*`,
  `pushPull_coprod_prod_empty`, and `lem:modules_isoSpec_ext_transport` (closed iter-057) as
  sorry-free but `\leanok`-less. Likely a `private`-decl name-resolution gap and/or sync running
  against an uncommitted tree. **Force a sync re-run and verify the private-decl path.** This is NOT
  laundering (decls verified closed first-hand); it is an accounting gap that hides real progress in
  the blueprint web.

## Coverage debt (dag-query unmatched — planner to blueprint)
- `AlgebraicGeometry.isZero_modules_of_isEmpty` (CSI, line 970; `private lemma`, `[leanok]`): new
  this iter. Supports `pushPull_coprod_prod_empty` (a sheaf of modules over an empty/initial scheme
  is the zero object; proof reflects `𝟙 = 0` through faithful `toPresheaf`, subsingleton sections).
  Its obligation is already described in the parent lemma's prose; add a brief
  `\lean{AlgebraicGeometry.isZero_modules_of_isEmpty}` pin or `% NOTE` so the DAG tracks it.
- `AlgebraicGeometry.CechAcyclic.affine`: dead, pre-existing — recommend deletion.

## Reusable proof patterns (also in PROJECT_STATUS Knowledge Base)
- **Definitional codomain bridges**: before building an explicit transport iso between two
  pushforward-continuous-functor codomains, CHECK whether `sheafPushforwardContinuousComp` /
  `Over.mapForget` make it `rfl`. The φ'' "wall" (a named blocker for 4 iters) was a defeq identity.
- **Empty/initial scheme zero object**: `isZero_modules_of_isEmpty` recipe — `toPresheaf.map_injective`
  + `Module.subsingleton ↑Γ(Z,U) _` (route via `Subsingleton Γ(M,U)` then `exact h`) + `Subsingleton.elim`;
  coproduct-over-`PEmpty` base is initial via `isColimitEquivIsInitialOfIsEmpty` + `isInitial_iff_isEmpty`.
- **Product/coproduct reindex along an equivalence**: `Sigma.whiskerEquiv`/`Pi.whiskerEquiv` with
  `Iso.refl` factor isos; close the over-morphism leg with `simp [Sigma.ι_comp_map']` (NOT `rw` — motive
  failure) and the product leg with `erw [Pi.lift_π]` (syntactic-key vs defeq); supply explicit
  `(f:=)(g:=)` to `Sigma.whiskerEquiv` (metavar codomain).
- **Thin opens-morphism naturality**: unit/counit squares of scheme-iso slice adjunctions collapse via
  `Scheme.Hom.congr_app φ.hom_inv_id` (`.inv_hom_id`) + `congr 1`/`Subsingleton.elim` over the preorder
  opens-hom, then `CommRingCat.forgetToRingCat_map_hom` + `erw key2; rfl`.
