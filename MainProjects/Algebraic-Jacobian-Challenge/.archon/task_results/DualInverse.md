# DualInverse.lean — fine-grained pass (iter-303)

Lane 1 objective: close `sliceDualTransport` ≃ₗ — finish `invFun` + round-trips, attempt
`naturality`. `invFun` is wired to `sliceDualTransportInv`, so the real content was closing
`sliceDualTransportInv`'s `app` + `naturality`.

## HEADLINE: `sliceDualTransportInv.app` is now FULLY CLOSED (was a bare `sorry`).

The reverse slice-transport component — the documented ~100-LOC instance-delicate residual that had
been CHURNING since iter-265 — is closed axiom-clean. File still compiles (`lake env lean` EXIT 0).

### Sentence-level decomposition of `sliceDualTransportInv.app` (blueprint `lem:slice_dual_transport_inv`)

The blueprint's 5-step recipe (X-slice mirror of the forward `toFun`, conjugated across the
propositional preimage round-trip `he : f''ᵁ(f⁻¹ᵁ W') = W'`) decomposed into:

1. **Source relabel** `M.val.map (eqToHom (op he.symm))` → RESOLVED (concrete). Semilinear; its
   codomain is restricted along `ρ = X.ringCatSheaf.map (eqToHom (op he.symm)) : 𝒪_X(W')→𝒪_X(fP)`.
2. **`?collapse` — double-restrict collapse** `M.val(fP) ≅ restrictScalars (f.appIso P).hom
   (restrictScalars (β.app P) (M.val fP))` → **RESOLVED axiom-clean** via
   `ModuleCat.restrictScalarsId'App ∘ restrictScalarsComp'App`, fed the ring identity
   `(β.app P).hom ∘ (f.appIso P).hom.hom = 𝟙` (see `hβ` below).
3. **`core` — ψ-reindex (leg 3) + codomain unit swap (leg 4)** `restrictScalars (f.appIso P).hom
   |>.map (ψ.app …) ≫ dualUnitRingSwapHom f P` → RESOLVED (concrete in fiber `𝒪_X(fP)`). The
   `(restr V 𝟙_Y)`-section vs `𝟙_ (ModuleCat 𝒪_Y(P))` unit-spelling reconciled by defeq, exactly as
   in the closed forward `toFun`.
4. **Cross-fiber transport** → RESOLVED. A single `≫`-chain cannot express it (the relabel crosses
   the `𝒪_X(W') ↔ 𝒪_X(fP)` ring fibers); realised by applying the functor `restrictScalars ρ` to
   `?collapse ≫ core`.
5. **`?unit` — codomain unit transport** `restrictScalars ρ 𝟙_X(fP) ⟶ 𝟙_X(W')` → **RESOLVED** via
   the new helper `unitRelabelSwap` (`inv ε` of the relabel ring map).

### KEY STRUCTURAL FINDING (planner-relevant): `sliceDualTransportInv` needed a β-compatibility hypothesis.

`?collapse` requires the ring identity `(β.app P).hom ∘ (f.appIso P).hom = 𝟙_{𝒪_X(fP)}`, which is
**FALSE for the abstract `β` parameter** — it holds only for the specific `β = (f.appIso).inv` that
`invFun` passes. The abstract-`β` signature was therefore *unprovable as stated*. Fix (the def is not
protected; I own the signature + its single caller): added hypothesis
`(hβ : ∀ P, (β.app (op P)).hom.comp ((f.appIso P).hom.hom) = RingHom.id _)`, discharged at the unique
caller (`sliceDualTransport.invFun`) via `Iso.hom_inv_id` of the structure ring iso (axiom-clean).

### New axiom-clean top-level declarations (verified: only `propext`/`Classical.choice`/`Quot.sound`)

- `isIso_ε_restrictScalars_presheafMap {a b : (Opens X)ᵒᵖ} (e : a = b)` — `ε` of `restrictScalars
  (X.presheaf.map (eqToHom e))` is an iso (bijective eqToHom-induced relabel; phrased at the
  `X.presheaf` CommRingCat carrier so `CommRing` is native).
- `unitRelabelSwap (e : a = b) : restrictScalars (X.presheaf.map (eqToHom e)) (𝟙_X(b)) ⟶ 𝟙_X(a)` —
  `inv ε`. Needed because the direct in-place `inv ε` cannot be *formed* at the `app` call site (the
  `set`-local `W'` blocks call-site synthesis of `CommRing ↑(X.presheaf.obj (op W'))`).

## Remaining sorries (all naturality / round-trips — separate substantial pieces)

| Decl | Open field(s) | Blocker |
|---|---|---|
| `sliceDualTransportInv` (L298) | `naturality` only (app CLOSED) | thin-poset square over `(Over fV)ᵒᵖ` for the full 4-leg composite; `Subsingleton.elim` on base maps but the 4 legs must slide through the restriction `.map` (`erw`-paste mirroring `homLocalSection.naturality`). Parallels still-open forward naturality. |
| `sliceDualTransport` (L407) | `naturality`, `left_inv`, `right_inv` | `left_inv`/`right_inv` are the `Iso.inv_hom_id`/`hom_inv_id` round-trips of `f.appIso` + down-set bijection — now reachable since `invFun`'s `app` is concrete, but need the naturality squares first. `naturality` = thin-poset `Subsingleton.elim` + ε-naturality. |
| `dual_restrict_iso` (L728) | `isoMk` naturality | assembly residual; thin-poset coherence of the `sliceDualTransport` family. |

## Summary

- **Sentences closed:** the entire `sliceDualTransportInv.app` (5 of 5 sub-steps), i.e. the
  ~100-LOC reverse-component residual that drove the iter-265→302 CHURNING verdict.
- **Sorry count (raw `sorry` terms in file): 6 → 5.** `sliceDualTransportInv` 2 sorries → 1.
- **New axiom-clean infrastructure:** 2 helpers (`isIso_ε_restrictScalars_presheafMap`,
  `unitRelabelSwap`) + the `hβ` hypothesis machinery + the `?collapse` collapse + the caller proof.
- **Signature change (within owned, non-protected scope):** `sliceDualTransportInv` gained the `hβ`
  β-compatibility hypothesis; the sole caller updated.
- File compiles `lake env lean` **EXIT 0**; closed helpers verified axiom-clean.

## Why I stopped

**Real progress:** `sliceDualTransportInv.app` closed (6→5 sorries), 2 new axiom-clean helpers, the
`?collapse` ring-identity core + `hβ` discharge. This is the genuine load-bearing piece of the dual
route-2 — the X-slice mirror morphism that was the single hardest documented residual.

**Partial / open with precise blockers:** the four naturality/round-trip sorries above. The
`sliceDualTransportInv.naturality` and `sliceDualTransport.naturality` are thin-poset squares that
need the multi-leg composite slid through the restriction `.map` (an `erw`-paste à la
`homLocalSection.naturality`) — not attempted this pass (the `app` close consumed the budget).
`left_inv`/`right_inv` are now genuinely reachable (invFun's app is concrete) and are the recommended
next target: `Iso.inv_hom_id`/`hom_inv_id` of `f.appIso` + the `image_preimage_of_le` down-set
bijection + the iter-265 `dualUnitRingSwap*` cancellation `@[simp]` pair.

**Recommended next prover directive:** target `sliceDualTransport.left_inv`/`right_inv` (now
unblocked) and the two naturality squares (build the forward `sliceDualTransport.naturality` first as
the template, then mirror for `sliceDualTransportInv.naturality`).

## Blueprint marker note (for review agent)

`lem:slice_dual_transport_inv` (`sliceDualTransportInv`): the **statement** is formalized and its
`app` is proven; only `naturality` remains `sorry`, so the proof block is NOT yet `\leanok`-complete
(the deterministic `sync_leanok` will keep it statement-`\leanok` / proof-unmarked, which is correct).
The two new helpers `isIso_ε_restrictScalars_presheafMap` / `unitRelabelSwap` are axiom-clean and
candidates for `\lean{}` hints if the planner wants them blueprinted.
