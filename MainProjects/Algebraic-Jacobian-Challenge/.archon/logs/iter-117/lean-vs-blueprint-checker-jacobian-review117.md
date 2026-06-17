# Lean ↔ Blueprint Check Report

## Slug
jacobian-review117

## Iteration
117

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean` (226 lines)
- Blueprint: `blueprint/src/chapters/Jacobian.tex` (250 lines)

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (chapter: `def:IsAlbanese`)
- **Lean target exists**: yes (line 57, `def IsAlbanese`).
- **Signature matches**: yes. Blueprint says "smooth proper geometrically irreducible group scheme $J$ over $k$ is an Albanese object for $(C, P)$ if there exists $\iota : C \to J$ sending $P$ to $\eta$, and every $f : C \to A$ with $f(P) = \eta_A$ factors uniquely as $f = \iota \circ g$." Lean encodes the four hypotheses on $J$ as typeclass parameters (`[GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]`) — matches `rem:IsAlbanese_typeclasses` — and the body is `∃ α : C ⟶ J, P ≫ α = η[J] ∧ ∀ {A : ...} [...] (f : C ⟶ A) (_ : P ≫ f = η[A]), ∃! (g : J ⟶ A), f = α ≫ g`.
- **Proof follows sketch**: N/A (definition, no proof body).
- **notes**: The remark `rem:IsAlbanese_typeclasses` correctly anticipates the typeclass binder convention and matches the Lean encoding exactly. The hypothesis on the target abelian variety $A$ is also installed via `[...]` binders inside the universal-property quantifier, as the remark anticipates.

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (chapter: `thm:IsAlbanese_unique`)
- **Lean target exists**: yes (line 88, `theorem unique`).
- **Signature matches**: **partial**. Blueprint prose says "Any two Albanese objects for the same pointed curve $(C, P)$ are **uniquely isomorphic by an isomorphism** compatible with their universal morphisms." The Lean statement is `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e` — just a unique compatible **morphism**, not stated as an isomorphism. The Lean proof (lines 94–114) actually establishes the iso content (`hgh : g ≫ h = 𝟙 J₁` line 104, `hhg : h ≫ g = 𝟙 J₂` line 113) but then returns only `⟨g, hg_eq, fun g' hg' => hg_unique g' hg'⟩`, discarding the invertibility witnesses. Statement is strictly weaker than blueprint prose.
- **Proof follows sketch**: yes. Blueprint sketch: "each of the two universal morphisms factors through the other, the two composites equal the unique self-factorisation $\mathrm{id}$, hence each factorisation is an isomorphism." Lean proof: gets $g$ (factoring $\iota_2$ through $\iota_1$), gets $h$ (factoring $\iota_1$ through $\iota_2$), shows $g \circ h = g_1 = \mathrm{id}$ and $h \circ g = k_2 = \mathrm{id}$. Mathematical content matches; conclusion is simply not returned in the strong "isomorphism" form.
- **notes**: The proof produces strictly more than the statement claims (it computes the isomorphism, then throws it away). Either tighten the statement to `∃! (e : J₁ ≅ J₂), h₂.ofCurve = h₁.ofCurve ≫ e.hom`, or weaken the blueprint prose to match.

### `\lean{AlgebraicGeometry.Jacobian}` (chapter: `def:Jacobian`)
- **Lean target exists**: yes (line 199, `noncomputable def Jacobian`).
- **Signature matches**: yes. Blueprint: "the abelian variety $\Jac(C)$ over $k$ ... viewed as an object of the category of $k$-schemes over $\Spec k$. Formally, $\Jac(C)$ is defined as the underlying scheme of a (uniform-over-$P$) Albanese witness for $C$." Lean: `Jacobian C : Over (Spec (.of k)) := (jacobianWitness C).J`. Exact match.
- **Proof follows sketch**: N/A.
- **notes**: Protected declaration; signature frozen and matches `archon-protected.yaml:9`.

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` (chapter: `thm:Jacobian_grpObj`)
- **Lean target exists**: yes (line 209).
- **Signature matches**: yes. Blueprint: "$\Jac(C)$ carries a canonical group-object structure"; Lean: `instance instGrpObj : GrpObj (Jacobian C) := (jacobianWitness C).grpObj`.
- **Proof follows sketch**: yes. The blueprint proof has two paragraphs: a Lean-side paragraph saying "inherits by projection from the witness's `grpObj` field" (matches exactly) and a mathematical paragraph deferred to the abstract universal-property argument (the latter is the content of `nonempty_jacobianWitness`).
- **notes**: Protected declaration. Honest projection.

### `\lean{AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus}` (chapter: `thm:Jacobian_smooth_genus`)
- **Lean target exists**: yes (line 213).
- **Signature matches**: yes. Blueprint: "$\Jac(C) \to \Spec k$ is smooth of relative dimension $g(C)$"; Lean: `instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom`. Predicate name matches prose precisely (`SmoothOfRelativeDimension n` vs the loose "smooth" — the chapter pins the right Mathlib predicate).
- **Proof follows sketch**: yes. Lean-side projection from `witness.smoothGenus`; mathematical content delegated to `nonempty_jacobianWitness`.
- **notes**: Protected declaration. Honest projection.

### `\lean{AlgebraicGeometry.Jacobian.instIsProper}` (chapter: `thm:Jacobian_proper`)
- **Lean target exists**: yes (line 217).
- **Signature matches**: yes. Blueprint: "$\Jac(C) \to \Spec k$ is proper"; Lean: `instance instIsProper : IsProper (Jacobian C).hom`.
- **Proof follows sketch**: yes. Lean projects `witness.proper`; mathematical content (FGA / Stein factorisation) deferred to `nonempty_jacobianWitness`.
- **notes**: Protected declaration. Honest projection.

### `\lean{AlgebraicGeometry.Jacobian.instGeometricallyIrreducible}` (chapter: `thm:Jacobian_geomIrred`)
- **Lean target exists**: yes (line 220).
- **Signature matches**: yes. Blueprint: "$\Jac(C) \to \Spec k$ is geometrically irreducible"; Lean: `instance instGeometricallyIrreducible : GeometricallyIrreducible (Jacobian C).hom`.
- **Proof follows sketch**: yes. Lean projects `witness.geomIrred`; mathematical content (identity component / Stein factorisation) deferred to `nonempty_jacobianWitness`.
- **notes**: Protected declaration. Honest projection.

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (chapter: `thm:nonempty_jacobianWitness`)
- **Lean target exists**: yes (line 176, `theorem nonempty_jacobianWitness`).
- **Signature matches**: yes. Blueprint: "There exists a smooth proper geometrically irreducible group scheme $J$ over $k$ of relative dimension $g(C)$ such that, for every $k$-rational point $P \in C(k)$, the scheme $J$ is an Albanese object for $(C, P)$." Lean: `Nonempty (JacobianWitness C)`, where `JacobianWitness` bundles all the required structure plus `isAlbaneseFor : ∀ P, IsAlbanese C P J ...`. Quantifier order ($\exists J, \forall P$) matches the prose.
- **Proof follows sketch**: N/A (`:= sorry`, line 179). The blueprint's `\begin{proof}` does NOT marker `\leanok` for the body itself — the chapter is honest about deferral. Route A (Picard scheme), Route B (Sym^g / Stein), and the genus-0 sub-case are each developed in 4 sub-steps with explicit Mathlib gaps listed.
- **notes**: The sole sorry in the file. **Authorised by the blueprint** as the project's "single explicit foundational hypothesis" (line 238 of the chapter). The directive explicitly lists this as a known issue. Sorry is properly disclosed in the Lean doc-comment (lines 162–175) and in the chapter prose. Note: the chapter places `\leanok` *inside* the `\begin{theorem}` block (line 138) and *inside* the `\begin{proof}` block (line 148). The proof-side `\leanok` is questionable — the proof body in Lean is `:= sorry`, so per the marker vocabulary in `.archon/CLAUDE.md`, `\leanok` inside a proof block should be removed by the deterministic `sync_leanok` phase. This is a `sync_leanok`-phase concern, not an authoring concern; the prose itself is honest about the deferral.

## Red flags

### Placeholder / suspect bodies
- `nonempty_jacobianWitness` at line 179: body is `:= sorry`. The blueprint **authorises** this sorry as the project's foundational existence hypothesis (chapter line 238, three routes named with explicit Mathlib gaps). Not a red flag in this iter per the directive.

### Excuse-comments
None. The Lean doc-comments around `nonempty_jacobianWitness` (lines 162–175) and `JacobianWitness` (lines 128–142) are accurate disclosures, not excuses — they correctly describe what is deferred and why.

### Axioms / Classical.choice on non-trivial claims
- `IsAlbanese.ofCurve` (line 67), `IsAlbanese.comp_ofCurve` (line 72), `IsAlbanese.exists_unique_ofCurve_comp` (line 78), and `jacobianWitness` (line 184) all use `Classical.choose` / `Classical.choice` on the `IsAlbanese` existential and the `Nonempty (JacobianWitness C)` proposition respectively. This is the standard pattern for extracting data from a propositional existence and is authorised by the blueprint's `nonempty_jacobianWitness` hypothesis. Not a red flag.

## Unreferenced declarations (informational)

Six Lean declarations have no `\lean{...}` block in the chapter. Three are substantive enough to deserve blueprint pointers; three are reasonable internal helpers.

**Substantive — recommended for blueprint reference:**
- `AlgebraicGeometry.JacobianWitness` (structure, line 143). The bundle is referenced informally in `def:Jacobian` ("uniform-over-$P$ Albanese witness for $C$") and `thm:nonempty_jacobianWitness` ("uniformly over the marked point"), and named directly in `chapters/Modules_Monoidal.tex` as `$\mathtt{JacobianWitness}$`, but no dedicated `\def{}` or `\structure{}` block points at it. The directive explicitly asks to verify such a block exists; it does not. The `isAlbaneseFor : ∀ P, IsAlbanese C P J ...` field is the mathematically novel part of the bundling (compared to a $\forall P, \exists J, ...$ phrasing) and deserves a definition block.
- `AlgebraicGeometry.IsAlbanese.ofCurve` (line 67), `.comp_ofCurve` (line 72), `.exists_unique_ofCurve_comp` (line 78). These three lemmas extract the data and conclusions of an `IsAlbanese` term via `Classical.choose`. They feed directly into the **protected** declarations `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` in `AbelJacobi.lean:20–22, 51–90` (verified by grep — they have no other usage in the codebase beyond the local `IsAlbanese.unique` proof). The chapter mentions $\iota$ informally in `def:IsAlbanese` but doesn't pin the extracted-morphism API. Since the extraction trio is what makes the bundled `IsAlbanese` usable as data, a remark or lemma block listing them would close the gap.

**Helper-only — acceptable to leave unreferenced:**
- `AlgebraicGeometry.jacobianWitness` (line 184). Implementation detail: `Classical.choice` of `nonempty_jacobianWitness`. The chapter refers to it once in `def:Jacobian`'s proof prose (`thm:Jacobian_grpObj`'s proof says "extracted from Theorem~\ref{thm:nonempty_jacobianWitness} via \texttt{Classical.choice}"), which is adequate; no `\lean{...}` block is necessary.
- `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (line 120). Lean comment says "small helper needed for the genus-0 case of `Jacobian`." Verified by grep: declared in `Jacobian.lean` and referenced **nowhere else** in the codebase. With the witness-based `Jacobian` definition the helper is no longer needed by this file; it's plausibly vestigial from a pre-`JacobianWitness` formulation. Either remove it or carry forward (low priority).

## Blueprint adequacy for this file

- **Coverage**: 8 of 14 substantive Lean declarations have a corresponding `\lean{...}` block (the 8 listed in the "Per-declaration" section). 6 unreferenced: 3 substantive (`JacobianWitness`, `IsAlbanese.ofCurve`/`comp_ofCurve`/`exists_unique_ofCurve_comp`) + 2 reasonable helpers (`jacobianWitness`, `geometricallyIrreducible_id_Spec`) + 1 trio counted as one (the `ofCurve`-extraction lemmas are three declarations but conceptually one API). The four protected witness-projection instances are each individually tagged — good.
- **Proof-sketch depth**: **adequate**. The `nonempty_jacobianWitness` proof block is genuinely impressive in this iter: it decomposes the deferral into three independent routes (Picard scheme, Sym^g + Stein, genus-0 rigidity), each with 3–4 explicit sub-steps and an explicit "Mathlib status" list naming exactly what's missing for each route. A future prover landing one of the three Mathlib build-outs ($\alpha$, $\beta$, $\gamma$ at chapter lines 233–236) could attack the corresponding route directly. The proof blocks of `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred` are each structured as "Lean-side: project field $X$ of the witness" + "Mathematical content: this is what the witness gives you, and here is why," which honestly discloses the deferral.
- **Hint precision**: **precise**. Every `\lean{...}` resolves to the right declaration. The smooth-of-relative-dimension predicate is pinned to `SmoothOfRelativeDimension (genus C)` in both prose and `\lean{...}`, avoiding the "smooth-vs-smoothOfRelativeDimension" failure mode called out in the checker spec.
- **Generality**: **matches need**. The blueprint encoding correctly anticipates the `JacobianWitness` bundle as a uniform-over-$P$ structure rather than a $\forall P, \exists J$ statement; the prose says "for every $k$-rational point $P$, the scheme $J$ is an Albanese object" — the order $\exists J, \forall P$ matches the bundle structure.
- **Recommended chapter-side actions**:
  1. **Add a `\def{}` or `\structure{}` block** for `AlgebraicGeometry.JacobianWitness` (directive-requested). It should describe the bundling and the `isAlbaneseFor` field's universal role. This would clarify why the existence statement is `Nonempty (JacobianWitness C)` rather than the prose-style $\exists J, \forall P, \mathrm{IsAlbanese}\,C\,P\,J$.
  2. **Add a short remark or lemma block** pointing at `AlgebraicGeometry.IsAlbanese.ofCurve`, `.comp_ofCurve`, `.exists_unique_ofCurve_comp`. These are the data-extraction API of `IsAlbanese` and feed directly into the protected `Jacobian.ofCurve` family in `AbelJacobi.lean`. A two-sentence "Extracting the universal morphism" remark, with three `\lean{...}` hints, would close the coverage gap.
  3. **Tighten `thm:IsAlbanese_unique` either on the prose side or the Lean side** so the statement matches: either change the prose from "uniquely isomorphic by an isomorphism" to "uniquely related by a compatible morphism" (matching the current Lean `∃! e`), or change the Lean to return `∃! (e : J₁ ≅ J₂), ...` (matching the current prose). The Lean proof already computes the isomorphism content (`hgh`, `hhg`), so the latter is the more faithful fix.
  4. **Reconsider the in-proof `\leanok` on `thm:nonempty_jacobianWitness`** (chapter line 148). The proof body is `:= sorry`, so the in-proof `\leanok` should be removed by the deterministic `sync_leanok` phase. Verify the post-prover sync handled this. (This is a `sync_leanok` concern, not a writer concern, but worth noting since the directive asks the chapter to "honestly disclose the deferral.")

## Severity summary

- **must-fix-this-iter**: none. The single sorry (`nonempty_jacobianWitness`) is explicitly authorised by both the directive and the blueprint; the chapter has been expanded this iter with the requested 3-route decomposition and the Mathlib-gap disclosure that the directive asked for. The four protected instances are honest witness projections; signatures match prose exactly.
- **major**:
  - `thm:IsAlbanese_unique` — Lean statement is strictly weaker than the blueprint prose ("unique compatible morphism" vs "unique isomorphism"); the Lean proof actually establishes the iso content but discards it. Fix by tightening one side.
  - `JacobianWitness` structure has no dedicated `\def{}` / `\structure{}` blueprint block (directive-requested).
  - `IsAlbanese.ofCurve` / `.comp_ofCurve` / `.exists_unique_ofCurve_comp` are unreferenced in the blueprint despite feeding directly into the protected `AbelJacobi.Jacobian.ofCurve` family.
- **minor**:
  - `JacobianWitness` has redundant fields `smooth : Smooth J.hom` and `smoothGenus : SmoothOfRelativeDimension (genus C) J.hom`; Mathlib lemma `AlgebraicGeometry.SmoothOfRelativeDimension.smooth` shows the second implies the first, so `smooth` could be derived. Implementation cleanup, not a correctness issue.
  - `geometricallyIrreducible_id_Spec` is defined but unused anywhere in the codebase; either remove or carry forward. Was needed in a pre-witness formulation of `Jacobian`.
  - In-proof `\leanok` at chapter line 148 (inside the `nonempty_jacobianWitness` proof block) should be removed by `sync_leanok` since the Lean body is `:= sorry`.

Overall verdict: The Lean ↔ blueprint correspondence on the **tagged** declarations is faithful and honest about the single foundational sorry; the chapter's iter-117 expansion of `thm:nonempty_jacobianWitness` substantially closes the previous "under-specified" gap. Two clusters of work remain: tighten the `IsAlbanese.unique` statement-vs-prose mismatch, and add blueprint blocks for the `JacobianWitness` structure and the `IsAlbanese.ofCurve`-extraction API trio so that the substantive declarations feeding `AbelJacobi.lean`'s protected interface are fully blueprint-anchored.
