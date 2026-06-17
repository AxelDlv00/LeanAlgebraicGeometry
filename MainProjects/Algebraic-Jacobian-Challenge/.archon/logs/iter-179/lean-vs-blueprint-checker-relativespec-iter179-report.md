# Lean ↔ Blueprint Check Report

## Slug
relativespec-iter179

## Iteration
179

## Files audited
- Lean: `AlgebraicJacobian/Picard/RelativeSpec.lean`
- Blueprint: `blueprint/src/chapters/Picard_RelativeSpec.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (chapter: `def:qc_sheaf_of_algebras`)
- **Lean target exists**: yes — `structure QcohAlgebra (X : Scheme.{u})` at L143–158.
- **Signature matches**: partial. Blueprint prose pins "sheaf of `O_X`-algebras whose underlying `O_X`-module is quasi-coherent". Lean encodes this as a 3-field structure: (i) `sheaf : TopCat.Sheaf CommRingCat.{u} X.toPresheafedSpace`, (ii) `unit : X.sheaf ⟶ sheaf`, (iii) `coequifibered : NatTrans.Coequifibered (Functor.whiskerLeft (AffineZariskiSite.toOpensFunctor X).op unit.hom)`. The Stacks-01LL `Coequifibered` predicate is strictly weaker than the full `SheafOfModules.IsQuasicoherent` claimed by the prose, but the Lean docstring (L137–142) acknowledges they are equivalent under `AffineZariskiSite.sheafEquiv`. The encoding is now genuinely non-tautological (iter-179 Block A upgrade — was 2-field iter-174).
- **Proof follows sketch**: N/A (definition).
- **notes**: Field (iii) is the iter-179 Block A landing referenced in the directive. The associativity / commutativity / unit-law content of the prose is enforced by `sheaf` being valued in `CommRingCat`, so the field set is structurally sound.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (chapter: `thm:relative_spec_exists`)
- **Lean target exists**: yes — `noncomputable def RelativeSpec` at L192–193.
- **Signature matches**: partial. Body is `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`, a substantive Mathlib value — no longer the iter-176 placeholder `:= X`. The Lean defines only the scheme; the structure morphism is a separate `RelativeSpec.structureMorphism`. The blueprint statement also asserts the existence of `π` and the two affine-open compatibility clauses; the Lean defers `π` to the auxiliary `structureMorphism` and the two compatibility clauses to the `relativeGluingData` machinery (not surfaced as separately-named theorems).
- **Proof follows sketch**: yes — the construction matches the blueprint's "glue affine pieces `Spec(𝒜(U))` via quasi-coherence transition isomorphisms" sketch via the Mathlib `Cover.RelativeGluingData` infrastructure (`AffineZariskiSite.directedCover`).
- **notes**: This iter's body change resolves the iter-176 CRITICAL "weakened-wrong" finding flagged in the directive.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (chapter: `thm:relative_spec_univ`)
- **Lean target exists**: yes — `theorem UniversalProperty` at L269–294.
- **Signature matches**: **no**. Blueprint prose pins the natural bijection `Hom_X(T, Spec_X(𝒜)) ≅ Hom_{O_X-alg}(𝒜, g_* O_T)` (representability of the Stacks 01LQ functor `F`). Lean encodes only the structural consequence `IsAffineHom (RelativeSpec.structureMorphism 𝒜)`. The blueprint's own iter-173 `% NOTE` (L160–164) explicitly acknowledges this gap and pins iter-174+ as the upgrade horizon.
- **Proof follows sketch**: partial — the Lean closes the weaker affineness claim using `isAffineHom_of_forall_exists_isAffineOpen` + `relativeGluingData.toBase_preimage_eq_opensRange_ι` + `isAffineOpen_opensRange`. This is a genuine proof (not `inferInstance` against an identity placeholder), but it does not formalize the Zariski-sheaf / open-subfunctor argument written in the blueprint's `\begin{proof}` (L228–239).
- **notes**: Iter-179 Lane B closed this kernel-clean (per directive). Body is now substantive and downstream-consumable, but at a strictly weaker type than the prose pins.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` (chapter: `thm:relative_spec_affine_base`)
- **Lean target exists**: yes — `theorem affine_base_iff` at L316–323.
- **Signature matches**: **no**. Blueprint prose pins the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X, 𝒜))`. Lean encodes the weaker `IsAffine ((Spec R).RelativeSpec 𝒜)`. The Lean name `affine_base_iff` is misleading — the encoded type is not an iff. Blueprint's iter-173 `% NOTE` (L249–254) acknowledges both gaps.
- **Proof follows sketch**: partial — Lean closes via `isAffine_of_isAffineHom` chained off `UniversalProperty`. This is a real "affine over affine is affine" step, but it does not formalize the explicit `f_univ : Spec(A) → Spec(R)` + `φ_univ` representability argument written in the blueprint's `\begin{proof}` (L304–323).
- **notes**: Iter-179 Lane B closed this kernel-clean. The iter-176 `% NOTE` on the proof block (L295–303) says the proof "reduces to `change IsAffine (Spec R); inferInstance`" — that is **now stale**; the current proof goes through `UniversalProperty` + `isAffine_of_isAffineHom`.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` (chapter: `thm:relative_spec_base_change`)
- **Lean target exists**: yes — `theorem base_change` at L367–371.
- **Signature matches**: **no**. Blueprint prose pins the canonical iso `T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)` with the explicit pullback algebra `g^* 𝒜` named. Lean encodes the weaker existential `∃ 𝒜', Nonempty (pullback g (structureMorphism 𝒜) ≅ T.RelativeSpec 𝒜')`. Blueprint's iter-173 `% NOTE` (L333–337) acknowledges this gap.
- **Proof follows sketch**: partial — Lean witnesses with the helpers `QcohAlgebra.pullback g _𝒜` and `pullback_iso g _𝒜`. The `base_change` term itself is a 1-line existential tuple, but **the substantive content is delegated to two helpers that each carry a `sorry`** (see Red flags below). So while `base_change` is technically kernel-clean as a term, it is a substantive placeholder via delegation.
- **notes**: The iter-176 `% NOTE` on the proof block (L373–383) says the proof witnesses with "the trivial pullback-algebra carrier and the iso `asIso (pullback.fst g (𝟙 X))`" — that is **now stale**; the current term-mode proof uses the two named helpers above the namespace, which encode real (if `sorry`-bodied) Mathlib values.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` (chapter: `thm:relative_spec_functorial`)
- **Lean target exists**: yes — `noncomputable def functor` at L395–397.
- **Signature matches**: **no**. Blueprint prose pins a contravariant `Functor (X.QcohAlgebra)^op (Over X)`, plus the equivalence onto the full subcategory of affine `X`-schemes, plus the universal pushforward iso `π_* O_{Spec_X(𝒜)} ≅ 𝒜`. Lean encodes only the bare object-level function `X.QcohAlgebra → Over X`. Blueprint's iter-173 `% NOTE` (L405–410) acknowledges this gap.
- **Proof follows sketch**: yes (def body) — `fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)`. This is a real (non-`sorry`) body.
- **notes**: The docstring at L388–394 says the body "is left as `sorry` here because `RelativeSpec.structureMorphism` is itself a typed `sorry`". This is **doubly stale**: (i) `structureMorphism` is no longer a typed `sorry` (iter-179 Block A upgrade); (ii) the actual `functor` body is no longer a `sorry` — it is the `fun 𝒜 => Over.mk (...)` value the docstring describes as the post-upgrade form.

## Red flags

### Placeholder / suspect bodies
- `Scheme.QcohAlgebra.pullback` at `RelativeSpec.lean:236`: `coequifibered := sorry` on the third structure field. The helper is consumed by `base_change` (substantive blueprint pin `thm:relative_spec_base_change`). Substantive type: the field requires `NatTrans.Coequifibered` of the pushforward-along-affine-`q` of the `O_X`-algebra unit; Stacks 01LR pullback compatibility. **Known per directive.**
- `Scheme.RelativeSpec.pullback_iso` at `RelativeSpec.lean:357`: full body `sorry`. The helper is consumed by `base_change`; it asserts `Nonempty (pullback g (structureMorphism 𝒜) ≅ T.RelativeSpec (QcohAlgebra.pullback g 𝒜))` — the actual canonical base-change iso content. **Known per directive.**

Net effect: `base_change` is term-level kernel-clean (1-line `⟨_, _⟩`), but two of its substantive subterms are placeholders. Counts as a placeholder body on a blueprint-pinned substantive declaration via delegation.

### Excuse-comments
- `RelativeSpec.lean:388-394`: docstring of `RelativeSpec.functor` claims the body "is left as `sorry`" because `structureMorphism` is itself a typed `sorry`. Both clauses are stale: `structureMorphism` is no longer a sorry (now `.toBase`), and the `functor` body at L395–397 is the concrete `fun 𝒜 => Over.mk (...)`. This is a stale workflow-rationale that contradicts the live code.
- `RelativeSpec.lean:387-394` and `RelativeSpec.lean:249-254` etc. contain repeated "iter-174+: refine the signature to a `CategoryTheory.Functor.RepresentableBy` witness…" notes. These are project-standard roadmap notes (not "we use a wrong def for now" excuses), but combined with the surviving signature weakenings they document a gap that has now slipped a meaningful number of iters; worth surfacing.

### Axioms / Classical.choice on non-trivial claims
- None. No `axiom` declarations and no `Classical.choice` patterns appear in the file.

## Unreferenced declarations (informational)

The file contains three substantive declarations that are NOT referenced by any `\lean{...}` block in the chapter:

- `AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism` (L208–210). Genuinely auxiliary — surfaces the `.toBase` morphism so `UniversalProperty`/`base_change`/`functor` can refer to it. Acceptable as an unblocked helper; the Lean file's own commentary (L195–199) labels it as such.
- `AlgebraicGeometry.Scheme.QcohAlgebra.pullback` (L229–236). This is iter-179 Lane B's "pullback of a qcoh algebra along `g : T ⟶ X`" constructor. It is substantive (carries the entire Stacks-01LR pullback-compatibility claim on its `coequifibered := sorry` field) and is the literal `g^* 𝒜` that the blueprint pins by name in `thm:relative_spec_base_change`. Worth promoting to its own `\lean{...}`-tagged blueprint block (e.g. `def:qc_pullback`).
- `AlgebraicGeometry.Scheme.RelativeSpec.pullback_iso` (L353–357). The canonical base-change iso, currently a substantive `sorry`. The blueprint's `thm:relative_spec_base_change` prose names this iso explicitly but does not pin it as a separate `\lean{...}` declaration. Worth promoting to a separately-pinned blueprint helper or folding into `thm:relative_spec_base_change` as a co-pin.

## Blueprint adequacy for this file

- **Coverage**: 6/6 blueprint pins map to declarations in the Lean file. Unreferenced Lean declarations: 1 acceptable helper (`structureMorphism`) + 2 substantive helpers (`QcohAlgebra.pullback`, `pullback_iso`) that the blueprint references in prose but does not pin via `\lean{...}`. **Coverage flagged: 2 substantive helpers missing pins.**
- **Proof-sketch depth**: adequate. Each of the four theorem blocks carries a substantive `\begin{proof}` sketch and the verbatim Stacks SOURCE QUOTE PROOF citation. The Lean proofs in this iter take simpler routes than the prose sketches (especially `UniversalProperty` and `affine_base_iff`), but that is a Lean-side signature-weakening artefact, not a blueprint-depth deficiency.
- **Hint precision**: **loose**. `thm:relative_spec_univ` prose pins the Yoneda bijection; `thm:relative_spec_affine_base` prose pins the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`; `thm:relative_spec_base_change` prose pins the named iso with `g^*𝒜`; `thm:relative_spec_functorial` prose pins a `Functor`. In all four cases the `\lean{...}` hint pins a Lean target whose actual type is a structurally weaker structural consequence. The chapter's own `% NOTE` (iter-173 review) comments correctly diagnose each gap, but the gap has now lived through iter-174..iter-179 without closure.
- **Generality**: matches need. The chapter scopes itself appropriately and the "Out of scope" section is honest about what is deferred.
- **Stale prose / NOTE comments** (this is the highest-value chapter-side action this iter):
  - L61–75 `% NOTE (iter-174 review)` claims the Lean carrier is the 2-field Encoding I form. **Stale**: iter-179 Block A lands the 3rd `coequifibered` field. Update the NOTE to describe the iter-179 carrier and the `relativeGluingData` adoption.
  - L218–227 `% NOTE (iter-176 review)` on `thm:relative_spec_univ` proof says the Lean proof "reduces to `inferInstance` on `IsAffineHom (𝟙 X)` via the priority-900 `[IsIso f] → IsAffineHom f` instance". **Stale**: iter-179 closes with a real proof via `isAffineHom_of_forall_exists_isAffineOpen` + `relativeGluingData.toBase_preimage_eq_opensRange_ι`.
  - L295–303 `% NOTE (iter-176 review)` on `thm:relative_spec_affine_base` proof says the proof is "`change IsAffine (Spec R); inferInstance`". **Stale**: iter-179 chains through `UniversalProperty` + `isAffine_of_isAffineHom`.
  - L373–383 `% NOTE (iter-176 review)` on `thm:relative_spec_base_change` proof says the proof uses "`asIso (pullback.fst g (𝟙 X))`". **Stale**: iter-179 witnesses with the named helpers `QcohAlgebra.pullback` + `pullback_iso` (sorry-bodied but real).
- **Recommended chapter-side actions** (for the catalog's blueprint-writing subagent):
  - Refresh the four iter-174/iter-176 `% NOTE` blocks listed above to describe the iter-179 carrier + proof terms; add a new `% NOTE (iter-179 review)` per block noting "carrier upgraded; proof now substantive; signature still pinned to weaker form pending iter-180+ upgrade to `RepresentableBy` / canonical iso / `Functor`".
  - Add `\lean{AlgebraicGeometry.Scheme.QcohAlgebra.pullback}` and `\lean{AlgebraicGeometry.Scheme.RelativeSpec.pullback_iso}` blocks (definitions / helper theorems) so the two new substantive helpers are blueprint-pinned. Either as their own blocks under `\section{Base change}` or as sub-pins of `thm:relative_spec_base_change`.
  - Either upgrade the Lean type of `UniversalProperty` / `affine_base_iff` / `base_change` / `functor` to the prose-pinned forms in a future Lane (the standing iter-174+ commitment), OR replace the prose with an explicit "we encode the structural consequence; the full Yoneda bijection is deferred" statement so the chapter's contract matches what the file actually proves. The current half-and-half (prose pins X, NOTE acknowledges Lean does Y) is the worst of both worlds for downstream consumers.

## Severity summary

- **must-fix-this-iter**:
  - Substantive `sorry` bodies on `QcohAlgebra.pullback.coequifibered` (L236) and `pullback_iso` (L357). These are auxiliary helpers, but `base_change` (a blueprint pin) delegates all substantive content to them, so `base_change` is a placeholder via delegation. *(Known to the directive — flagged here for severity bookkeeping only; per the checker rules a known issue does not become "major" just because it is known.)*
  - Signature mismatches between blueprint prose and Lean type on four pins: `UniversalProperty` (Yoneda bijection vs `IsAffineHom`), `affine_base_iff` (canonical iso vs `IsAffine`; name is misleading), `base_change` (named-iso vs existential), `functor` (categorical `Functor` vs object-level `→`). The blueprint `% NOTE` comments acknowledge each gap, but per the checker rules a wrong/weakened signature is must-fix regardless of acknowledgement.
- **major**:
  - Stale `% NOTE` review comments at blueprint L61–75, L218–227, L295–303, L373–383 — each one now describes a Lean state that no longer exists after iter-179 Block A + Lane B. Misleading to a future planner.
  - Stale docstring at `RelativeSpec.lean:388-394` (claims `functor` body is `sorry`; it is not, and the rationale that `structureMorphism` is `sorry` is also stale).
  - 2 substantive helpers (`QcohAlgebra.pullback`, `pullback_iso`) lack `\lean{...}` pins despite carrying substantive `sorry` content that downstream consumers will need.
- **minor**:
  - Naming drift: `affine_base_iff` is not an `iff` (its encoded type is `IsAffine`).
  - Roadmap-only notes in Lean docstrings ("iter-174+: refine to…") have now persisted across 5 iters; harmless but worth a one-line refresh once the upgrade actually lands.

Overall verdict: iter-179 Block A meaningfully closes the iter-176 CRITICAL `RelativeSpec := X` weakening — bodies are now genuine Mathlib values, and the two proven theorems use real gluing infrastructure — but the four pinned theorems still encode strictly weaker structural-consequence types than the blueprint prose pins, two substantive helpers carry `sorry`, and four `% NOTE` review comments in the blueprint are now factually stale.
