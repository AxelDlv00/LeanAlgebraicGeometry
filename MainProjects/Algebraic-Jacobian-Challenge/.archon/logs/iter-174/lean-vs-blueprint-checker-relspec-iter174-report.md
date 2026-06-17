# Lean ↔ Blueprint Check Report

## Slug
relspec-iter174

## Iteration
174

## Files audited
- Lean: `AlgebraicJacobian/Picard/RelativeSpec.lean`
- Blueprint: `blueprint/src/chapters/Picard_RelativeSpec.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (chapter: `def:qc_sheaf_of_algebras`)
- **Lean target exists**: yes — `structure QcohAlgebra (X : Scheme.{u})` at line 131, two fields (`sheaf : TopCat.Sheaf CommRingCat.{u} X.toPresheafedSpace`, `unit : X.sheaf ⟶ sheaf`).
- **Signature matches**: **partial**. Blueprint prose (lines 52-58) requires (a) sheaf of `O_X`-algebras and (b) underlying `O_X`-module is **quasi-coherent**. Encoding I captures (a) via the `CommRingCat` carrier + unit, but the quasi-coherence overlay (b) is **NOT** encoded — explicitly deferred to iter-175+ per the docstring + `analogies/qcohalgebra-structure.md` Decision 1 (NEEDS_MATHLIB_GAP_FILL: sheafified-tensor monoidal structure on `SheafOfModules X.ringCatSheaf` is missing from Mathlib at the pinned commit `b80f227`).
- **Proof follows sketch**: N/A (definition).
- **notes**: Carrier is axiom-clean (`propext`, `Classical.choice`, `Quot.sound` only). Structure is non-tautological. The Lean *name* `QcohAlgebra` is mildly aspirational — the structure encodes "sheaf of `O_X`-algebras" but not yet the quasi-coherent overlay. The docstring (lines 108-130) is candid about this and shows the upgrade path (add `isQcoh : Prop` once `SheafOfModules.IsQuasicoherent` infrastructure lands upstream).

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (chapter: `thm:relative_spec_exists`)
- **Lean target exists**: yes — `noncomputable def RelativeSpec` at line 160.
- **Signature matches**: **partial**. Lean signature is just `X.QcohAlgebra → Scheme`. The blueprint promises (i) a scheme together with (ii) an affine morphism `π`, (iii) isomorphisms `i_U` over affine opens with (iv) the open-immersion cocycle condition. None of (ii)-(iv) is part of the signature; `structureMorphism` is a separate (sorry-bodied) helper at line 171.
- **Proof follows sketch**: **no** — body is `sorry`. Blueprint provides a substantive proof sketch (Mathlib `Scheme.GlueData` / `AffineScheme.glueOpens`, transition iso from quasi-coherence, Stacks `lemma-transitive-spec` for cocycle).
- **notes**: Per directive's "out of scope" clause for this lane; body fill is iter-175+ work. The sketch in the blueprint is detailed enough to body-fill.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (chapter: `thm:relative_spec_univ`)
- **Lean target exists**: yes — `theorem UniversalProperty` at line 206.
- **Signature matches**: **no**. Blueprint prose pins the natural bijection
  `Hom_X(T, Spec_X(𝒜)) ≅ Hom_{O_X-alg}(𝒜, g_* O_T)` (i.e. a `Functor.RepresentableBy` witness for the Stacks 01LQ functor). Lean encodes it as `IsAffineHom (RelativeSpec.structureMorphism 𝒜)` — a structural consequence, not the universal property itself.
- **Proof follows sketch**: **no** — body is `sorry`.
- **notes**: Acknowledged divergence — both the Lean docstring (lines 187-191) AND the blueprint's `% NOTE (iter-173 review):` comment (lines 145-149) explicitly flag this as a must-upgrade-iter-174+ item. Per directive's "out of scope" clause.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` (chapter: `thm:relative_spec_affine_base`)
- **Lean target exists**: yes — `theorem affine_base_iff` at line 230.
- **Signature matches**: **no**. Blueprint claims the *canonical iso* `Spec_X(𝒜) ≅ Spec(Γ(X, 𝒜))`. Lean only says `IsAffine ((Spec R).RelativeSpec 𝒜)` — the bare affineness consequence. The Lean *name* `affine_base_iff` is misleading (the encoded type is no kind of iff).
- **Proof follows sketch**: **no** — body is `sorry`.
- **notes**: Acknowledged divergence — blueprint `% NOTE (iter-173 review):` (lines 223-228) calls out both (a) the type-weakening and (b) the misleading name. Per directive's "out of scope" clause.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` (chapter: `thm:relative_spec_base_change`)
- **Lean target exists**: yes — `theorem base_change` at line 260.
- **Signature matches**: **partial**. Blueprint claims a canonical iso `T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)` with a *named* pullback `g^* 𝒜`. Lean encodes existentially `∃ 𝒜', Nonempty (pullback g (structureMorphism 𝒜) ≅ T.RelativeSpec 𝒜')`, binding `𝒜'` instead of producing the named pullback.
- **Proof follows sketch**: **no** — body is `sorry`.
- **notes**: Acknowledged divergence — blueprint `% NOTE (iter-173 review):` (lines 300-304) flags the existential vs. canonical-iso shape and pins the iter-174+ refinement (factor out `pullbackQcoh g 𝒜`). Per directive's "out of scope" clause.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` (chapter: `thm:relative_spec_functorial`)
- **Lean target exists**: yes — `noncomputable def functor` at line 288.
- **Signature matches**: **no**. Blueprint claims a **contravariant functor** `QcohAlg(X)^op ⥤ AffSch/X`. Lean is a **bare object-level function** `X.QcohAlgebra → Over X` — no `Functor` packaging, no `op`, no `AffSch` restriction, and no morphism action.
- **Proof follows sketch**: N/A (definition body). The body is `fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)` — concrete, but transitively gated on the sorry-bodied `structureMorphism`.
- **notes**: Acknowledged divergence — blueprint `% NOTE (iter-173 review):` (lines 363-368) calls out the bare-function shape. The docstring at lines 282-286 says the body "is left as `sorry` here" but that comment is now **stale**: the actual body is non-`sorry` (just transitively uses sorry through `structureMorphism`). Minor doc drift.

## Red flags

### Stale `\leanok` on proof blocks
- **`blueprint/src/chapters/Picard_RelativeSpec.tex:127`** — `\leanok` inside the proof block of `thm:relative_spec_exists`. The proof block's `\leanok` semantics (per `.archon/CLAUDE.md`) is "proof closed, no `sorry`". But the Lean target `RelativeSpec` (line 160) has body `:= sorry`. The `\leanok` marker is **stale**.
- **`blueprint/src/chapters/Picard_RelativeSpec.tex:418`** — `\leanok` inside the proof block of `thm:relative_spec_functorial`. The Lean target `functor` (line 288) has a non-`sorry` body, but that body is `fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)` and `structureMorphism` is itself `sorry`. The local `sorry_analyzer` count for `functor` is zero (so a syntactic scan considers the marker earned), but the *mathematical* content of "proof closed" is **not yet** met — the def is a thin wrapper around a sorry. Flagged as a softer warning.

The `sync_leanok` state file (`/.archon/sync_leanok-state.json`, iter-174) lists `chapters_touched` without `Picard_RelativeSpec.tex` — meaning the deterministic pass did NOT remove either marker. Either (a) `sync_leanok` does not currently manage proof-block `\leanok` for declarations bodied as direct `sorry`, or (b) both markers slipped past the syntactic check. Either way, the discrepancy with reality is real and worth surfacing.

### Stale docstring (informational)
- `RelativeSpec.lean:282-285` — docstring on `functor` reads *"the body is concrete via `Over.mk (RelativeSpec.structureMorphism 𝒜)` but is left as `sorry` here"* — but the body actually IS `fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)`. The "left as sorry" wording is leftover from iter-173 and should be tightened.

### Placeholder bodies on substantively-claimed declarations (acknowledged)
- `RelativeSpec` (line 160), `structureMorphism` (line 171), `UniversalProperty` (line 206), `affine_base_iff` (line 230), `base_change` (line 260) all have `:= sorry` bodies. The blueprint claims all are substantive theorems / a substantive scheme construction. **Acknowledged in the directive's "Known issues" list** as deliberately out-of-scope this lane; not re-flagged here.

### Axioms / `Classical.choice` on non-trivial claims
None added by Lane G. `QcohAlgebra` is axiom-clean (verified via `lean_verify`: `["propext", "Classical.choice", "Quot.sound"]`, no `sorryAx`).

## Unreferenced declarations (informational)

- `AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism` (line 171) — auxiliary `Scheme.RelativeSpec 𝒜 ⟶ X` morphism. Not in the 6 blueprint pins, but the chapter prose references "the structure morphism" throughout and the Lean docstring (lines 164-170) labels it as a helper. Acceptable as a helper: it factors the affine-morphism / Yoneda statements. Consider promoting to a `\lean{...}` reference in a future blueprint pass, but not necessary.

## Blueprint adequacy for this file

- **Coverage**: **6/6** Lean declarations cited as the lane's pinned set have corresponding `\lean{...}` blocks in the chapter. **1** helper (`structureMorphism`) unreferenced (acceptable).
- **Proof-sketch depth**: **adequate** for the *intended* blueprint targets. Each theorem block carries a concrete sketch (`thm:relative_spec_exists` → gluing via `Scheme.GlueData` + `lemma-transitive-spec`; `thm:relative_spec_univ` → Zariski sheaf + affine subfunctors; `thm:relative_spec_affine_base` → standard reduction to `Spec(Γ(X, 𝒜))`; `thm:relative_spec_base_change` → Yoneda + universal property; `thm:relative_spec_functorial` → naturality of the representing bijection + the `π_* O_{Spec(𝒜)} ≅ 𝒜` reconstruction). Stacks tag references are pinned per declaration and source quotes are embedded as comments. This is well above the minimum bar.
- **Hint precision**: **precise** on the Lean targets, but **loose** on *typed shape*. The 5 downstream `\lean{...}` hints point to declarations the chapter prose pins to one shape (e.g. `RepresentableBy` for `UniversalProperty`, canonical iso for `affine_base_iff`, named-pullback canonical iso for `base_change`, `Functor` for `functor`), but the Lean targets currently use weaker placeholder shapes. The blueprint's `% NOTE (iter-173 review):` comments document each divergence explicitly — this is good practice and the right place for the gap to live until iter-175+ refines the signatures.
- **Generality**: **matches need** on the prose side. The blueprint's "Lean encoding" section (lines 437-460) describes the intended assembly precisely (using `Scheme.GlueData` / `AffineScheme.glueOpens` / `CategoryTheory.Functor.RepresentableBy`); the encoding choice for `QcohAlgebra` (Encoding I vs. Encoding II) is the only generality gap, and `analogies/qcohalgebra-structure.md` Decision 1 documents the upstream-gap reason for the interim choice.
- **Recommended chapter-side actions**:
  - Drop or audit the two stale proof-block `\leanok` markers at L127 and L418 (or pass them through `sync_leanok` if there's a hidden bug that misses proof-block markers on direct-`sorry` bodies).
  - Optionally update `def:qc_sheaf_of_algebras` to acknowledge in prose that the iter-174 Lean target encodes the algebra structure but defers the quasi-coherence overlay (the chapter doesn't currently flag this — the Lean docstring does, and `analogies/qcohalgebra-structure.md` does, but the blueprint prose still describes the "fully quasi-coherent" form without noting the iter-174 partial encoding).
  - Optionally pin a `\lean{...}` for the helper `RelativeSpec.structureMorphism` — currently the chapter prose mentions "the structure morphism" but no formal pin exists; a `\lean{...}` would tighten the blueprint→Lean mapping.

## Verification of directive's specific asks

> Confirm whether the chapter's prose / proof sketches are sufficient to body-fill the 5 downstream pins.

**YES** for the *intended* (blueprint-prose) shapes — every theorem has a substantive proof sketch citing the right Mathlib backbones and Stacks lemmas. However, the iter-174 *Lean placeholder* signatures (e.g. `IsAffineHom`, `IsAffine`, existential base-change, bare `→`) do NOT have explicit blueprint-side proof sketches for those weaker shapes — the chapter sketches the FULL claims. The body-lane for iter-175+ should either (a) refine the Lean signatures up to the blueprint shapes before body-filling, or (b) add interim sketches to the blueprint for the weaker placeholder shapes. (a) is the directive-preferred path.

> Whether the `QcohAlgebra` definition prose matches the Encoding I 2-field structure.

**PARTIAL**. The blueprint prose pins the *full* quasi-coherent sheaf-of-algebras notion (with quasi-coherence overlay). The Encoding I structure captures the algebra-shape part (sheaf-of-`CommRingCat` + unit) but defers the quasi-coherence predicate. The Lane G report and Lean docstring acknowledge this. The blueprint prose itself does NOT acknowledge the partial encoding — a `% NOTE (iter-174):` line in `def:qc_sheaf_of_algebras` analogous to the iter-173 review notes on the theorem blocks would harmonize the bidirectional documentation.

> The chapter already carries `\leanok` on `def:qc_sheaf_of_algebras` per `sync_leanok-state.json` iter-173 + iter-174 markers; the iter-174 Lane G report claims this is "fully earned" — verify.

**EARNED for statement-block semantics**, with a caveat on the "fully" qualifier.

Per `.archon/CLAUDE.md`: statement-block `\leanok` semantics is *"declaration is formalized (at least a sorry present)"*. The Encoding I structure is now a real `structure` (not a typed sorry), non-tautological (`sheaf` + `unit`), and axiom-clean. The statement-block `\leanok` is genuinely earned.

However, the Lane G report's wording — *"this `\leanok` is **fully earned** (the structure is now non-tautological)"* — slightly elides the quasi-coherence gap. "Non-tautological" is true; "fully matches the blueprint definition" is not (the blueprint defines `QcohAlgebra` to include the quasi-coherent overlay; the Lean structure does not, by design, this iter). For sync_leanok purposes the marker is correct; for full-content-match purposes it is partial.

## Severity summary

- **must-fix-this-iter**: none.
  - The five `:= sorry` bodies are acknowledged in the directive's "Known issues" as out-of-scope this lane.
  - The `QcohAlgebra` partial encoding (no quasi-coherence overlay) is acknowledged in the directive's "Known issues" and is documented in the Lean docstring + `analogies/qcohalgebra-structure.md`.
  - No new axioms, no excuse-comments, no weakened-wrong definitions that aren't explicitly flagged in the source.
- **major**:
  - Stale `\leanok` on proof block of `thm:relative_spec_exists` at `Picard_RelativeSpec.tex:127` — proof claimed closed, Lean body is direct `sorry`. Either a sync_leanok blind spot or a marker that should be removed.
  - Stale `\leanok` on proof block of `thm:relative_spec_functorial` at `Picard_RelativeSpec.tex:418` — wrapping a sorry'd helper; locally non-`sorry` but transitively gated.
- **minor**:
  - Stale docstring at `RelativeSpec.lean:282-285` ("left as `sorry` here" no longer accurate; body is concrete).
  - Missing prose acknowledgement in `def:qc_sheaf_of_algebras` that the iter-174 Lean encoding omits the quasi-coherence overlay (currently only in the Lean docstring + analogy file).
  - Optional: `RelativeSpec.structureMorphism` would benefit from a blueprint `\lean{...}` pin.

**Overall verdict**: The iter-174 Lane G landing is sound — `QcohAlgebra` is genuinely non-tautological and axiom-clean, and the 5 downstream `sorry` bodies match the lane's explicit out-of-scope clause; the chapter's prose and proof sketches are detailed enough to guide iter-175+ body-filling once the signatures are refined to the blueprint shapes, with two stale proof-block `\leanok` markers and one stale docstring as the only fresh quality nits.
