# blueprint-writer bw-tos262 — directive

Update ONE chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. It is
the consolidated chapter covering `Picard/TensorObjSubstrate.lean` and
`Picard/TensorObjSubstrate/DualInverse.lean`. The blueprint-reviewer (br262) and
two file-vs-blueprint checks (lvb-di261, lvb-tos261) found the chapter has drifted
from the actual Lean for both active prover lanes; it currently FAILS the hard
gate. Repair the two proof sketches below. Do NOT touch any other chapter, any
`\leanok`/`\mathlibok` markers, or any block not named here.

Strategy context (the slice that matters): A.1.c.sub builds the line-bundle
comparison iso and the dual ⊗-inverse. Two lanes resume next: the dual
`sliceDualTransport`/`dual_restrict_iso` (route-2, by hand) and the D3′
`pullbackTensorMap_restrict` 4-square paste. The chapter must describe what the
Lean ACTUALLY does so a prover (running fine-grained mode on the dual, prove mode
on D3′) can extract the right atomic lemmas.

## FIX 1 — `lem:dual_restrict_iso` proof (the `sliceDualTransport` "leg-(A) atom"
paragraph, around lines 5757–5797; a `% NOTE (review iter-261)` at ~5780–5791
already lists the required edits — apply them to the prose and then you may remove
the NOTE).

The current prose is WRONG on three points; correct all three:

1. **Combined leg A∘B, not leg-A-only.** The Lean `sliceDualTransport f M V` is the
   per-`V` `𝒪_Y(V)`-linear iso packaging BOTH leg A (slice-Hom base-change reindex
   across `f.opensFunctor`) AND leg B (the unit ring-iso codomain swap) into ONE
   `LinearEquiv.toModuleIso`. `dual_restrict_iso` then calls
   `isoMk (fun V => sliceDualTransport f M V)` directly — there is NO separate
   leg-B step in `isoMk`. Rewrite the "Step-4 residual" description accordingly.

2. **Leg A is built via categorical `.map`, not eqToHom-conjugation.** The forward
   component at `W` is `(ModuleCat.restrictScalars β_W).map (φ.app …)` (categorical
   `.map`). Replace the "Concretely … eqToHom-conjugation across `f.opensFunctor`"
   description with the `.map` form, and add the load-bearing reason: a raw
   `ModuleCat.ofHom { toFun := … }` reduces the carrier and loses the
   `restrictScalars`/`pushforward₀` `𝒪_Y(V)`-module instance, so the map must be
   built categorically. (The eqToHom-conjugation pattern of `homLocalSection`/
   `dualUnitIsoGen` is NO LONGER the description for this atom.)

3. **Document leg B precisely — and that it is now UNBLOCKED.** Leg B is the unit
   ε-iso codomain swap. State it as: `codomainMap := inv (ε (ModuleCat.restrictScalars g))`
   where `g := (f.appIso W').inv.hom` is a **`CommRingCat`-level** ring hom, fed to
   the project lemma `restrictScalars_isIso_ε_of_bijective g`
   (PresheafInternalHom.lean, with `ConcreteCategory.bijective_of_isIso (f.appIso W').inv`).
   Two frictions were diagnosed in iter-261 and RESOLVED by a Mathlib-idiom consult
   (recipe in `analogies/ma-legb262.md`, which you may read):
   - (a) The earlier "CommRing-instance loss on `forget₂ CommRingCat RingCat`-imaged
     rings" is self-inflicted — phrasing the hom at the `CommRingCat` level (using
     `(f.appIso W').inv.hom`, NOT the `forget₂`'d `β.app`) makes `CommRing` native;
     `ModuleCat.restrictScalars` of the `forget₂`'d hom is `rfl`-equal to that of the
     `CommRingCat`-level hom, so leg A's domain still matches.
   - (b) The `𝟙_`-vs-`restr`-unit-section mismatch is pure defeq: a `show`/`change`
     canonicalizing the unit to the `𝟙_ (ModuleCat ↑(𝒪(U)))` (CommRingCat-carrier)
     form unifies the endpoints. (Never elaborate the unit at the `forget₂`-composite
     carrier — its `MonoidalCategoryStruct` does not synthesize.)
   Phrase these as the concrete construction the prover follows, not as a list of
   obstacles.

4. **Add the `\lean` hint.** Add `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}`
   to the chapter so the Lean target is identifiable. The cleanest placement is its
   own `\begin{lemma}[sliceDualTransport]\label{lem:slice_dual_transport}\lean{…}\uses{…}`
   block stating the per-`V` linear iso, inside or immediately before the proof of
   `lem:dual_restrict_iso`, with the proof sketch = legs A (`.map` reindex) ∘ B
   (the `inv ε` recipe above) + thin-poset naturality via `Subsingleton.elim`. Also
   add `\lean{PresheafOfModules.dualUnitIsoGen}` where that decl is named in the
   prose (~L5775).

## FIX 2 — `lem:pullback_tensor_map_basechange` (D3′) proof sketch (the
composition-coherence paste; the "genuinely missing ingredients" sentence at
~lines 4074–4076 is stale).

1. **Sq1 and Sq4 are no longer "missing".** Update the prose: Sq2/Sq2b
   (`pullbackComp_δ` + `pushforwardComp_lax_μ`) are CLOSED axiom-clean; Sq3
   (`sheafifyTensorUnitIso`) and Sq4 (`pullbackValIso`) coherences are proved; the
   sole open ingredient is **Sq1**, the composition coherence of
   `SheafOfModules.sheafificationCompPullback`, now a named project sub-lemma
   `sheafificationCompPullback_comp` (private). Give its statement form: for a
   presheaf `P` over `X` and `h, f`,
   `(pullbackComp h f).inv.app (a_X P) ≫ (pullback h).map ((sheafCompPb f).app P).hom
      ≫ ((sheafCompPb h).app (PresheafOfModules.pullback φ'_f P)).hom
      ≫ a_Z.map ((PresheafOfModules.pullbackComp φ'_f φ'_h).hom.app P)`
   equals the `(h∘f)`-connecting iso `((sheafCompPb (h∘f)).app P).hom`, proved by
   the `leftAdjointUniq` mate calculus (transpose via the composite adjunction,
   `homEquiv_leftAdjointUniq_hom_app`, then transport the two `pullbackComp` factors
   across the adjunction units — the `δ`-free twin of `pullbackObjUnitToUnit_comp`).
2. **Note the square interleaving.** Add a sentence: the four squares do NOT paste
   row-by-row — `S1_h` acts on `tensorObj ((pullback f).obj M) ((pullback f).obj N)`,
   NOT on `PresheafOfModules.pullback φ'_f (M⊗N)`, so factors must be slid past each
   other by `δ_natural`/NatTrans naturality before assembly (as in the D1′
   naturality paste).
3. **Drop the stale `\uses{lem:tensorobj_restrict_iso}`** from the
   `lem:pullback_tensor_map_basechange` statement block if present (it does not
   appear in the proof).

## Out of scope
- Do not edit any other chapter. Do not add/remove `\leanok`/`\mathlibok`. Do not
  rewrite blocks unrelated to FIX 1/FIX 2. Keep all existing `% SOURCE`/citation
  lines intact. The mathematical content of legs/squares is already correct — this
  is a description-accuracy repair, not new mathematics.
