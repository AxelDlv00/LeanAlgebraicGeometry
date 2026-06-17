# AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean

## Summary

- **Sorry count: 3 → 2.** Closed the ROOT `sliceDualTransportInv.naturality` (was L444).
  Remaining: `sliceDualTransport.left_inv` + `.right_inv` (both inside the single
  `sliceDualTransport` def, L632 — now the only `declaration uses sorry` in the file).
- **ROOT closed axiom-clean**: `lean_verify` on `sliceDualTransportInv` and
  `sliceDualTransportInv_naturality_apply` → `{propext, Classical.choice, Quot.sound}` (no `sorryAx`).
- **`lake build` of the module + all dependents: SUCCESS (8322 jobs).**

## sliceDualTransportInv.naturality (was L444, ROOT) — RESOLVED

### Approach (the working recipe, mirrors the forward `sliceDualTransport_naturality_apply`)
The `dualnat006` "morphism-level rotation" and any `erw`/`simp` of the ε-swap `_apply` lemmas on the
deep `inv ε` composite **time out at `whnf`** (confirmed again this iter). The route that works is the
**forward template's**: an extracted **clean-statement lemma** closed in the def by `exact` (defeq).

1. Added `sliceDualTransportInv_naturality_apply` (new lemma, before the def) — the pointwise
   naturality square stated with the two `inv ε` legs (`unitRelabelSwap`, `dualUnitRingSwapHom`) kept
   **shallow** and the down-set facts (`hPVX/heX/hPVY/heY`) passed explicitly so everything is nameable.
2. Closed the def's `naturality` field by
   `intro X₁ Y₁ f₁; apply ModuleCat.hom_ext; refine LinearMap.ext fun z => ?_; exact sliceDualTransportInv_naturality_apply … <down-set proofs>`.
   **Key insight**: `exact` matches by **defeq** — the `restrictScalars.map`/`restrictScalarsId'App.inv`/
   `restrictScalarsComp'App.hom` legs are `rfl`-identities and reduce automatically, while the ε-swaps
   sit in identical positions in goal and lemma so they match *structurally* (no `whnf` of `inv ε`).
   The down-set proofs are accepted by proof-irrelevance.

### Proof of `sliceDualTransportInv_naturality_apply`
After `rw [unitRelabelSwap_apply, …, dualUnitRingSwapHom_apply, …]` (now SHALLOW → cheap, no `whnf`)
the goal is a concrete element equation closed by **three ingredients**:
- **`hM` (M-side coherence)**: `Mr_Y ∘ Mf₁ = (restr V (pushforward β M.val)).map g ∘ Mr_X` — both are
  `M.val`-restrictions of `z`. Reduced each side to `M.val.map …` via two `show … from rfl`
  (`pushforward_obj_map_apply`/`restr` are `rfl` on carriers), fused with a local `fuse` lemma
  (`M.val.map_comp; rfl`) applied by `erw` (defeq, dodges the `ConcreteCategory.hom` vs
  `ModuleCat.Hom.hom` normal-form mismatch), `congr 1` + `Subsingleton.elim` on the thin poset.
- **ψ-naturality** (`PresheafOfModules.naturality_apply ψ`) at the slice morphism
  `f⁻¹ᵁ Y₁ ⟶ f⁻¹ᵁ X₁`, applied by `rw [hM, hψ]`.
- **appIso-naturality** (`Scheme.Hom.appIso_inv_naturality`) via `ConcreteCategory.congr_hom`, applied
  by `erw [hAI]`; then the X-side `X.presheaf` round-trip closes by a `CommRingCat` morphism identity
  (`hring`: `Category.assoc` + `← map_comp` + `Subsingleton.elim`) and `exact ConcreteCategory.congr_hom hring _`.

### Dead ends (documented for next agent)
- `subsingleton` / `Subsingleton.elim` on the outer naturality square: FAILS (source `restr fV M.val`
  is not subsingleton — only unit-*valued* isoMk squares collapse that way).
- `erw`/`simp [unitRelabelSwap_apply | dualUnitRingSwapHom_apply]` on the def's deep composite:
  `whnf` heartbeat timeout (the documented trap). Must extract a shallow-statement lemma first.
- `simp only [ModuleCat.restrictScalars.map_apply, …]`: does NOT fire — the goal carries
  `ModuleCat.Hom.hom` while the lemmas use `ConcreteCategory.hom`; they are defeq but not syntactic.
  Use `exact`/`erw` (defeq) or keep everything in one coercion form.

## sliceDualTransport.left_inv (was L724) — PARTIAL (reduced to final collapse)

### Progress (compiles; genuine code, not just an opener)
`intro φ; PresheafOfModules.hom_ext; ModuleCat.hom_ext; LinearMap.ext z`, then:
- `rw [sliceDualTransportInv_app_apply …]` (new `rfl` lemma) → clean reverse-app form;
- `simp only [ConcreteCategory.comp_apply, dualUnitRingSwapHom_apply, unitRelabelSwap_apply]` +
  `erw [dualUnitRingSwap_apply, CategoryTheory.Iso.hom_inv_id_apply]` — this **cancels the
  `appIso.inv ∘ appIso.hom = id` round-trip** (the heart of the inverse law).
- Established `hφ := PresheafOfModules.naturality_apply φ (eqToHom-relabel slice morphism)`.

Goal now: `X.presheaf.map(α) (φ.app S (M.val.map(γ) z)) = φ.app W'' z`, and `hφ` says
`φ.app S ((restr fV M.val).map g_rel z) = (restr fV 𝟙_X).map g_rel (φ.app W'' z)`.

### Remaining (one step)
`rw [hφ]` does not fire because the goal's `M.val.map (eqToHom (congrArg op he.symm))` matches
`(restr fV M.val).map g_rel` only up to **`eqToHom_op`** (`(eqToHom he).op = eqToHom (congrArg op he.symm)`)
— a propositional, not defeq, orientation difference (the `show … from rfl` mismatch confirms this).
NEXT: normalise the orientation (`rw [eqToHom_op]` on the goal or rebuild `g_rel` so the restr-map
underlying is *syntactically* the goal's relabel), `rw [hφ]`, then collapse the two `X.presheaf`-relabels
`α ≫ (restr fV 𝟙_X).map g_rel = 𝟙` via `← X.presheaf.map_comp` + `Subsingleton.elim` (`he` round-trip),
leaving `φ.app W'' z`. `PresheafOfModules.restr_map_homMk` is the relevant `rfl` bridge but is `private`
in `PresheafInternalHom.lean` (cannot be named here — re-derive inline or ask plan to de-privatise).

## sliceDualTransport.right_inv (was L726) — opener only
`intro ψ; hom_ext; ModuleCat.hom_ext; LinearMap.ext z; sorry`. Mirror of left_inv: the forward
`toFun` of `invFun ψ` collapses by the same `appIso.hom_inv_id` cancellation the other direction.
Apply `sliceDualTransportInv_app_apply` to expose `invFun`'s clean app, then the forward
`dualUnitRingSwap`/`dualUnitRingSwapHom` cancel.

## Needs blueprint entry
- `sliceDualTransportInv_naturality_apply` (lemma, ~L390) — new. Uses: `PresheafOfModules.naturality_apply`,
  `Scheme.Hom.appIso_inv_naturality`, `pushforward_obj_map_apply` (rfl), `unitRelabelSwap_apply`,
  `dualUnitRingSwapHom_apply`, `Subsingleton.elim`. Pointwise naturality of the reverse slice transport.
- `sliceDualTransportInv_app_apply` (lemma, ~L556) — new, `rfl`. Clean pointwise form of the
  reverse-transport `app` component (leg reductions are definitional). Reused by `left_inv`/`right_inv`.

## Why I stopped
**Real progress**: closed 1 sorry — the ROOT `sliceDualTransportInv.naturality` (was L444), the
multi-iteration blocker that gates the whole DUAL chain (`exists_tensorObj_inverse`). Verified
axiom-clean and the full module + dependents `lake build` succeeds (8322 jobs). Added two reusable,
proven helper lemmas. Sorry count 3 → 2.
**Partial progress** on `left_inv`: reduced from a bare sorry to a concrete one-step goal with the
`appIso` round-trip already cancelled and the φ-naturality square (`hφ`) in hand; the only remaining
obstacle is a named, specific `eqToHom_op` orientation alignment (documented above). `right_inv` has a
structural opener. I stopped because the `eqToHom_op` alignment + `X.presheaf` round-trip is several more
careful steps and the `restr_map_homMk` bridge is `private`; the headline ROOT result is solid, verified,
and unblocks downstream, so I locked it in with a clean build rather than risk it on a long alignment grind.
