# Recommendations — after iter-236

## TOP PRIORITY — the d.2 bottleneck is GONE; wire the consumer

**`PresheafOfModules.stalkTensorIso` is built, axiom-clean, non-vacuous, and imported.** This is
the single ingredient that has gated the unconditional associator (and hence
`thm:pic_commgroup`) for ~19 iters. The next plan iter should **dispatch a prover lane on
`Picard/TensorObjSubstrate.lean`** to:

1. Consume `stalkTensorIso` to close `isLocallyInjective_whiskerLeft_of_W` UNCONDITIONALLY
   (a `J.W`-morphism is a stalkwise iso; `(F ◁ g)_x = id ⊗ g_x` is an iso via the d.2 iso).
2. Transport the presheaf associator through sheafification → `mul_assoc` → close
   `thm:pic_commgroup`.
3. Per the prover's standing handoff: repoint `thm:rel_pic_addcommgroup_via_tensorobj`'s `\uses`
   to `thm:pic_commgroup`.

This is the first time this lane is unblocked. It is the highest-value move in the project.
HARD-GATE note: `Picard_TensorObjSubstrate.tex` covers `TensorObjSubstrate.lean` and was rated
complete+correct for the d.2 sub-section; confirm the associator sub-section is gate-clean before
dispatch (the consumer lemmas may need a blueprint check).

## SECOND — FlatBaseChange blueprint must be fixed BEFORE the next FBC object-iso prover round

`lean-vs-blueprint-checker-flatbasechange-ts236.md` flags two MAJOR blueprint gaps. Dispatch a
**blueprint-writer for `Cohomology_FlatBaseChange.tex`** (write-domain includes `references/**`):

1. **Add three `\lean{}`-pinned blocks** for the iter-236 outputs (currently invisible to the
   blueprint): `globalSectionsIso_hom_comp_specMap_appTop` (ring-square naturality),
   `gammaPushforwardIso` (general-`N` Γ-fragment iso — make this the primary block),
   `gammaPushforwardTildeIso` (tilde corollary). Exact statements in the checker report §
   "Recommended chapter-side actions".
2. **Fix the circular QC dependency** in `lem:pushforward_spec_tilde_iso`'s proof sketch. The
   current remark argues "QC closed under iso ⇒ pushforward is QC", but QC of the pushforward is
   a PREREQUISITE for the object iso (built via `fromTildeΓ`, an iso iff the pushforward is QC),
   not a corollary. Rewrite to flag QC as the hard prerequisite and describe a non-circular route
   (the `IsLocalizedModule`-on-basic-opens route (iii), which yields object iso + QC at once).

Then re-run the lean-vs-blueprint-checker scoped to this chapter to clear the gate.

## FlatBaseChange object iso — for when the blueprint is fixed
The object iso `pushforward_spec_tilde_iso` reduces to ONE obligation: quasi-coherence of
`(Spec φ)_*(tilde M)`. Recommended attack = **route (iii)**: direct basic-open
`Modules.isIso_of_isIso_app_of_isBasis` (already in this file) + `IsLocalizedModule`
(`(restrictScalars φ M)` localised at `a` = `M` localised at `φ a`). This yields the object iso
AND QC simultaneously — the most efficient route. The other two QC routes (Presentation;
`IsQuasicoherent.of_coversTop`) are documented fallbacks.

## DO NOT RETRY
- **Route (a) section-level `map_smul'` finisher for the Γ-fragment iso** (FlatBaseChange). The
  `LinearEquiv`/`AddEquiv.refl` approach is a confirmed DEAD END: it reduces to `A • m = B • m`
  but every element-level finisher hits the alias-vs-reduced-type `HSMul`-synth wall (`congr 1`
  → `whnf` timeout; `congr 2` → `RingHom`+`HEq`). The element-free route (b) is the fix and is
  now BUILT — do not re-derive it.
- **`flatBaseChange_pushforward_isIso`** (deep Čech + flatness): leave as the documented sorry
  per PROGRESS.md. Gated on `affineBaseChange_pushforward_iso` + Mathlib-absent SheafOfModules
  Čech cohomology. Not a per-iter target.

## Comment-quality cleanups (lean-auditor ts236, 3 major — for the file owners next prover round)
These are NOT must-fix and do not block, but the prover that next touches each file should fix:
- **`StalkTensor.lean:21–24`** — module header still says the full iso is deferred to
  `task_results`; the iso and all machinery are now IN the file. Stale/misleading.
- **`StalkTensor.lean:425–426`** — `revBihom_balanced` docstring names
  `revBihom_balanced_section` (nonexistent); the actual helper is `revBihom_balanced_germ`.
- **`FlatBaseChange.lean:181–244`** — long STATUS/UPDATE history block with iter-numbered labels
  and ~35 lines documenting the abandoned route (a) embedded in a section header. Belongs in the
  proof journal; will grow stale. Trim to the current route-(b) API description.

## Reusable proof patterns discovered this iter
- **Varying-ring section balancing without the carrier wall:** prove `(r₀•a)⊗b = a⊗(r₀•b)` at the
  `R(W)` (CommRingCat, `R'=R`) section level where `TensorProduct.smul_tmul` synthesises, then
  transport via `congrArg ((tensorObj A B).map j.op)` + `erw [tensorObj_map_tmul]`. NEVER use
  `map_smul` at `W ⊓ W` (RingCat carrier → `smul_tmul` synth fails). And WRAP bare-tmul section
  identities in `germ` to supply the expected `Module` type (else `A.presheaf.obj` vs `A.obj`
  synth failure).
- **Element-free ModuleCat iso across a propositional ring-naturality equation:** when two
  carriers are defeq but their `Module` instances differ by a ring-hom-naturality eq, build the
  iso at the functor level via `restrictScalarsComp'App` (peel both sides to nested
  `restrictScalars` towers, `rfl`-confirmed) + `eqToIso (congrArg … hcomp)` for the ring eq.
  Avoids the element-level `smul` wall entirely.
- **`TensorProduct.induction_on` carrier bridge:** tmuls come out over the `RingCat`
  (`R ⋙ forget₂`) carrier; germ-char lemmas use `R.obj` (CommRingCat). Bridge with `erw` (defeq),
  not `rw`; for zero/add cases use `erw [map_zero…]`/`erw [map_add…]` (`simp only` makes no
  progress on `ConcreteCategory.hom`-applied terms).
