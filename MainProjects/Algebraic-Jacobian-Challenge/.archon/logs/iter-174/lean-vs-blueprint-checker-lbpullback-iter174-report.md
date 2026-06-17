# Lean ↔ Blueprint Check Report

## Slug
lbpullback-iter174

## Iteration
174

## Files audited
- Lean: `AlgebraicJacobian/Picard/LineBundlePullback.lean` (319 LOC, file-skeleton)
- Blueprint: `blueprint/src/chapters/Picard_LineBundlePullback.tex` (449 LOC, 5 `\lean{}` pins)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.LineBundle.OnProduct}` (chapter: `def:line_bundle_on_product`)
- **Lean target exists**: yes — `noncomputable def OnProduct {S C T : Scheme.{u}} (_πC : C ⟶ S) (_πT : T ⟶ S) : Type (u+1) := sorry` (L119–121).
- **Signature matches**: partial — blueprint defines "the type of invertible `O_(C×_kT)`-modules"; Lean encodes this by a typed sorry at the *type* level (`Type (u+1) := sorry`), mirroring the iter-173 `QcohAlgebra` precedent. The signature shape `(πC) (πT) ↝ Type (u+1)` is right; the meaning is deferred because Mathlib `b80f227` ships no `IsInvertible` on `Scheme.Modules`.
- **Proof follows sketch**: N/A (definition).
- **notes**: Authorized by directive (file-skeleton landing, Mathlib gap). The Lean comment (L92–98, L109–118) names the planned body (`subtype of (pullback πC πT).Modules` + `IsInvertible` witness).

### `\lean{AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection}` (chapter: `def:pullback_along_projection`)
- **Lean target exists**: yes — `noncomputable def pullbackAlongProjection {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) (_N : T.Modules) : OnProduct πC πT := sorry` (L150–152).
- **Signature matches**: partial — blueprint pins `Pic(T) → Pic(C×_kT)` (group/set hom). Lean signature is `T.Modules → OnProduct πC πT` (object-level map on the Modules category, valued in the typed-sorry `OnProduct` carrier). The `T.Modules` source is broader than `Pic(T)`; once `OnProduct` carves out invertibility, the restriction is the intended map. Consistent given Pin 1's deferral.
- **Proof follows sketch**: N/A (definition body is `sorry`).
- **notes**: Lean comment (L143–149) commits to `(Scheme.Modules.pullback (pullback.snd πC πT)).obj N` as the iter-175+ body — matches the chapter's prose route via `Mathlib.AlgebraicGeometry.Pullback`.

### `\lean{AlgebraicGeometry.Scheme.LineBundle.pullback_pullback_eq}` (chapter: `lem:pullback_compose`)
- **Lean target exists**: yes — `theorem pullback_pullback_eq` (L204–214). Stated as `Nonempty (iso between two Modules.pullback compositions)`.
- **Signature matches**: yes — blueprint states equality of pullback maps `g_C^* ∘ π_T^* = π_{T'}^* ∘ g^*` on `Pic`, equivalently a canonical natural isomorphism realising both sides as pullback along the composite. The Lean encoding `Nonempty ((Modules.pullback g_C).obj ((Modules.pullback (pullback.snd πC πT)).obj N) ≅ (Modules.pullback (pullback.snd πC πT')).obj ((Modules.pullback g).obj N))` is precisely the natural-iso form (the right form at the `Scheme.Modules` level, where equality holds only up to canonical iso). The composite `g_C = pullback.map πC πT' πC πT (𝟙 C) g (𝟙 S) _ _` matches `id_C ×_k g` from the blueprint diagram.
- **Proof follows sketch**: N/A (body is `sorry`). Sketch sufficient: blueprint cites the pullback-square commutativity + `Module.pullback_comp`; Lean comment (L200–202) commits to `Modules.pullbackComp` composed twice patched by `πT' = g ≫ πT` — direct execution of the chapter sketch.
- **notes**: The Lean takes `(N : T.Modules)` and existentially asserts an iso, where the chapter expresses the same fact as an equality of maps on isomorphism classes. Both formulations are equivalent. Fine.

### `\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.preimage_subgroup}` (chapter: `thm:relative_pic_quotient_well_defined`)
- **Lean target exists**: yes — `noncomputable def preimage_subgroup {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) : Setoid (LineBundle.OnProduct πC πT) := sorry` (L261–264).
- **Signature matches**: partial — blueprint introduces `H_T := π_T^* Pic(T) ⊆ Pic(C×_kT)` and asserts the quotient *set* `Pic(C×_kT)/H_T` is well-defined. Lean encodes this as a `Setoid (OnProduct πC πT)` — i.e. the underlying equivalence relation that the chapter's `\mathcal{L} \sim \mathcal{L}' \iff \mathcal{L} \otimes \mathcal{L}'^{-1} \in H_T`. The Lean encoding of the well-definedness of a quotient set as the `Setoid` carrier is canonical Mathlib idiom. **Naming drift**: the identifier is `preimage_subgroup` but the Lean returns a `Setoid`, not a `Subgroup` of `Pic(C×_kT)`. The Lean doc-comment (L233–235) addresses this drift ("project-side Lean encoding extracts the *Setoid* that the quotient construction takes") — acknowledged but the identifier reads misleadingly in isolation.
- **Proof follows sketch**: N/A (body is `sorry`). Sketch is detailed enough: blueprint gives the explicit relation and reflexivity / symmetry / transitivity argument; Lean comment (L256–260) commits to `Setoid` constructed from `∃ N : T.Modules, L ⊗ L'⁻¹ ≅ pullbackAlongProjection πC πT N`. Adequate.
- **notes**: `Pic(C×_kT)` doesn't appear as a separate type in the Lean (the quotient is taken directly on `OnProduct`) — this is the typical Lean idiom for "Picard group" pre-quotient. Acceptable.

### `\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.functorial}` (chapter: `thm:pullback_natural`)
- **Lean target exists**: yes — `noncomputable def functorial {S C T T' : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) (πT' : T' ⟶ S) (g : T' ⟶ T) (_hg : πT' = g ≫ πT) : Quotient (preimage_subgroup πC πT) → Quotient (preimage_subgroup πC πT') := sorry` (L309–312).
- **Signature matches**: **narrower** — blueprint promises the *full functor* `Pic^♯_{C/k} : (Sch/k)^op → Set` with `id_T^♯ = id` and `(g ∘ h)^♯ = g^♯ ∘ h^♯` (the chapter's last paragraph explicitly states both functor laws). The Lean signature is only the **object-level induced map** at a single fixed `g`, parameterised by the equality `πT' = g ≫ πT`. The identity/composition laws and the `(Sch/k)^op ⥤ Set` packaging are absent from the Lean (no `Functor` term, no `map_id` / `map_comp` lemmas). The directive's "known issues" explicitly authorises this gap for iter-174 — iter-175+ work.
- **Proof follows sketch**: N/A (body is `sorry`). Sketch is detailed enough for *both* (i) the object-level body (blueprint gives `Quotient.lift` of `g_C^* L` using `lem:pullback_compose` for well-definedness; Lean comment L302–306 commits to this) AND (ii) the iter-175+ functor packaging (blueprint cites `Modules.pullbackId` / `Modules.pullbackComp`; Lean comment names the same).
- **notes**: The Lean name `functorial` suggests the full functor; the signature only provides one functorial action. Either rename (e.g. `inducedMap`) or expand the iter-175+ body to land the full `Functor` term. Acknowledged in Lean doc-comment (L279–284): "we pin the object-level functorial action ... The full Functor packaging ... is iter-175+ work".

## Red flags

### Placeholder / suspect bodies
- All 5 declarations are `:= sorry` bodies on substantive claims. **Authorized by directive** as the iter-174 file-skeleton landing pattern (5 pins, all sorry-bodied; directive explicitly cites the iter-173 `QcohAlgebra` precedent for Pin 1's `Type (u+1) := sorry`). Not classified as must-fix per the directive's "known issues" carve-out.

### Excuse-comments
- None. The doc-comments label deferred bodies as "iter-175+" forward pointers (e.g. L109–118, L142–149, L200–202, L255–260, L302–307). These are file-skeleton roadmap markers explicitly authorized by directive, not excuse-comments for wrong code.

### Axioms / Classical.choice on non-trivial claims
- None. No `axiom` declarations. No `Classical.choice` on substantive claims.

## Unreferenced declarations (informational)

None — every declaration in the Lean file has a corresponding `\lean{...}` pin in the chapter. No helper-only declarations are introduced.

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean declarations have a corresponding `\lean{...}` block in the chapter. 0 helpers, 0 substantive unreferenced declarations. **Perfect 1:1 coverage.**
- **Proof-sketch depth**: **adequate**. Every pin's blueprint proof body gives enough detail for a prover to discharge the iter-175+ body:
  - `def:line_bundle_on_product`: explicit (open cover, free rank one, tensor product).
  - `def:pullback_along_projection`: cites `Module.pullback`-of-modules + Stacks 01HH (preservation of invertibility).
  - `lem:pullback_compose`: pullback square + `Module.pullback_comp` (composed twice).
  - `thm:relative_pic_quotient_well_defined`: subgroup-of-Picard observation + quotient construction.
  - `thm:pullback_natural`: commutative square from `lem:pullback_compose` + `Quotient.lift` + functor laws via `pullbackId`/`pullbackComp`.
- **Hint precision**: **loose in one spot**. The chapter's "Lean encoding" §6 claims `OnProduct` "is a re-export / type alias for the Mathlib invertible-module predicate ... `Mathlib.AlgebraicGeometry.Modules.Invertible` (or the equivalent ... `Mathlib.AlgebraicGeometry.LineBundle`)". The Lean file's doc-comment (L92–98) explicitly contradicts this: Mathlib `b80f227` ships no `IsInvertible` predicate on `Scheme.Modules`. The chapter over-promises Mathlib API availability; the Lean file-skeleton encodes this honestly via the typed sorry. **Chapter should be updated** to note the Mathlib API gap and what the project-side definition will be (matching the L109–118 Lean comment's planned `structure OnProduct ... where sheaf isInvertible`).
- **Generality**: **matches need** for pins 1–4 and 5's object-level action. **Too broad** for pin 5 in one direction: the chapter promises a full functor (with id + comp laws as part of the statement) while the Lean signature is only one induced map. This is iter-175+ scope per the directive; the chapter could split `thm:pullback_natural` into two pins (object-level `functorial : Quotient → Quotient` + functor-packaging `functor : (Sch/k)^op ⥤ Set` with `map_id` / `map_comp` fields) for clearer iter-175+ guidance.
- **Recommended chapter-side actions**:
  - **(minor)** Update §6 ("Lean encoding") L356–362 to reflect that `Mathlib.AlgebraicGeometry.Modules.Invertible` does NOT exist in `b80f227`; the project-side `OnProduct` is a fresh definition (structure pairing `Scheme.Modules` carrier + invertibility witness). The chapter's current phrasing risks misleading a prover into a fruitless Mathlib search.
  - **(minor)** Consider splitting `thm:pullback_natural` into `def:functorial_action` (object-level induced quotient map) + `thm:relPicPresheaf_functor` (full `(Sch/k)^op ⥤ Set` packaging with id/comp laws). The current Lean pin only addresses the first; the second is iter-175+ scoped.
  - **(minor)** Document the `preimage_subgroup`-name-returns-`Setoid` Lean encoding in §6 alongside the `\lean{}` pin so a downstream reviewer doesn't read the identifier as promising a `Subgroup` term.

## Severity summary

- **must-fix-this-iter**: none. The 5 `:= sorry` bodies are explicitly authorized by the directive as the iter-174 Lane E file-skeleton landing pattern (mirroring iter-173 `QcohAlgebra` precedent); the Pin 1 `Type (u+1) := sorry` is the documented Mathlib-gap workaround.
- **major**: none.
- **minor**:
  - Pin 4 `preimage_subgroup` identifier returns a `Setoid`, not a `Subgroup` — naming drift acknowledged in the Lean doc-comment but worth either renaming (e.g. `quotientSetoid`) on the iter-175+ unpacking pass OR adding a chapter-side note. Cosmetic.
  - Pin 5 `functorial` signature is narrower than blueprint `thm:pullback_natural` (object-level map only, no `Functor` packaging) — directive-authorized iter-175+ scope, but chapter-side splitting into two pins would clarify the scope boundary.
  - Blueprint §6 over-promises Mathlib API availability (claims `OnProduct` re-exports a Mathlib invertible-module predicate that doesn't exist in `b80f227`) — chapter prose should reflect the file's honest "Mathlib gap" stance.

**Overall verdict**: The iter-174 Lane E file-skeleton lands faithfully against its blueprint chapter (5/5 pin coverage, all signatures non-tautological, no excuse-comments, no axioms); blueprint sketches are adequate for the iter-175+ body fills; the only items worth iter-175+ chapter-side polish are one over-promise in §6 ("Lean encoding") about Mathlib API availability, and an optional split of `thm:pullback_natural` to reflect the object-level / functor-packaging boundary the Lean enforces.
