# Blueprint-writer directive — reconcile 01EO encoding + decompose 02KG affine instantiation

Chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated chapter; `% archon:covers` includes `CechToCohomology.lean`).

You have TWO jobs this iter. Both edit ONLY this chapter (and you may spawn a child
reference-retriever under `references/**` if you need a source you lack — but the two sources
you need are ALREADY local; see Reference anchors).

## Strategy context (the slice that matters)
The 01EO general Čech-to-cohomology basis criterion is now COMPLETE in Lean
(`CechToCohomology.lean`, 7 axiom-clean decls incl. `cech_eq_cohomology_of_basis`). The next
target is Stacks **Tag 02KG** Serre vanishing on affines (`lem:affine_serre_vanishing`), proved by
*instantiating* the 01EO criterion: basis B = affine (distinguished/standard) opens, Cov = standard
open covers. The chapter already has a thin `lem:affine_serre_vanishing` block (lines ~3131-3188)
that just says "instantiate"; the actual Lean instantiation is substantial and MUST be decomposed
into a `\uses`-linked chain of formalize-ready sub-lemmas so a prover can build it piece by piece.

The cover-system is encoded in Lean as `BasisCovSystem` (`def:basis_cov_system`), a structure with
FIVE fields (NOT the raw-cofinality shape the current prose describes):
  - `B : Opens X → Prop` (or a set) — the basis;
  - `Cov` — the admissible coverings (a set of `CovDatum = Σ ι, ι → Opens X`);
  - `faces_mem` — every finite intersection of a covering's opens lies in B (condition (1));
  - `surj_of_vanishing` — the SHEAF-THEORETIC OUTPUT field: for `V ∈ B` and a short exact sequence
    `S : ShortComplex X.Modules` whose left term has vanishing higher Čech cohomology over the
    covers of V, the section map `S.X₂(V) → S.X₃(V)` is surjective. (This is the *consequence* of
    cofinality + `ses_cech_h1`, packaged as a field — NOT the raw cofinality datum.)
  - `injective_acyclic` — for every injective `O_X`-module I and every cover in Cov, the positive-
    degree Čech cohomology `Ȟ^{>0}(𝒰, I)` vanishes (the `injective_cech_acyclic` output, Stacks
    `lemma-injective-trivial-cech`).
The per-module predicate `HasVanishingHigherCech s F` (`def:has_vanishing_higher_cech`) is condition
(3): `Ȟ^p(𝒰,F)=0` for all `𝒰 ∈ s.Cov`, `p>0`; deliberately abstract (F need not be quasi-coherent).

## JOB 1 — reconcile (clear the lvb-iter028 majors + coverage debt)

(a) **Rewrite `def:basis_cov_system` prose** (block at ~line 3301) to describe the ACTUAL five-field
    Lean structure above. In particular:
    - Replace the "cofinality datum stated in precisely the shape consumed by Lemma ses_cech_h1"
      sentence: the Lean has NO raw cofinality field; it has `surj_of_vanishing`, the section-
      surjectivity OUTPUT that cofinality + `ses_cech_h1` (`lem:ses_cech_h1`) produce.
    - ADD a description of the fifth field `injective_acyclic` (injective Čech-acyclicity for the
      system's covers, Stacks `lemma-injective-trivial-cech` = `lem:injective_cech_acyclic`).
    - DELETE the now-false claim "It carries no colimit or derived-functor machinery" — the
      structure carries two sheaf-theoretic (Čech-cohomology) fields.
    - Update `\uses{}` to include `lem:ses_cech_h1` and `lem:injective_cech_acyclic` (the fields'
      mathematical content), keeping `def:cech_complex`.
    - Add `\lean{}` pin for the helper `AlgebraicGeometry.CovDatum` (the `Σ ι, ι → Opens X` abbrev)
      by appending it to this block's `\lean{...}` list (so coverage debt clears).

(b) **Fix the L4 proof prose** (`lem:absolute_cohomology_pos_vanishing` proof, ~lines 3666-3713):
    the paragraph that says "the cofinality datum (condition (2)) then makes Lemma ses_cech_h1
    applicable at V_σ, giving section surjectivity" should be restated to match the field encoding:
    section surjectivity `I(V_σ)→Q(V_σ)` comes directly from the `surj_of_vanishing` field of the
    cover system applied to the SES, with the left-term Čech-vanishing hypothesis supplied by F's
    `HasVanishingHigherCech` + injective acyclicity. Keep the math identical; just align the
    description to the field shape. Also add the private helpers `AlgebraicGeometry.injSES` and
    `AlgebraicGeometry.injSES_shortExact` to this lemma's `\lean{...}` list (coverage debt).

(c) **Add `[EnoughInjectives X.Modules]` disclosure** to the visible statements of
    `lem:absolute_cohomology_pos_vanishing` (L4) and `lem:cech_to_cohomology_on_basis` (top) AND
    `lem:affine_serre_vanishing` (02KG): a short prose sentence noting that the Lean signature
    carries `[EnoughInjectives X.Modules]` as an explicit instance hypothesis because that instance
    is absent from Mathlib for sheaves of modules (it would follow from
    `IsGrothendieckAbelian (SheafOfModules R)`). Match the Lean file's comment. Do NOT change any
    `\leanok` markers (not your job).

(d) **Add `\lean{}` pin for `AlgebraicGeometry.sectionsFunctor`** to `lem:face_ses_of_sheaf_ses`'s
    `\lean{...}` list (the lemma's proof uses it explicitly; coverage debt).

(e) **Fix the `lem:cech_acyclic_affine` pin** (block at ~line 1179): REMOVE
    `AlgebraicGeometry.CechAcyclic.affine` from its `\lean{...}` list. That name is the OLD,
    superseded relative-form declaration (still carries a sorry as orphaned dead code in
    `CechAcyclic.lean:110`, used by nothing); the node's real content is realized by
    `AlgebraicGeometry.sectionCech_affine_vanishing` (+ the `CombinatorialCech.*` helpers already
    listed), which is axiom-clean. Keeping the dead name marks the node `[sorry]` and blocks the
    02KG frontier. Remove ONLY that one name; keep all the others. Update the explanatory comment
    above the `\lean{}` (lines ~1184-1188) to note the dead decl was de-pinned.

## JOB 2 — decompose `lem:affine_serre_vanishing` (Tag 02KG) into a formalize-ready chain

Replace the thin `lem:affine_serre_vanishing` proof with a decomposition into the sub-lemmas below,
each its own `\begin{lemma}` (or `\begin{definition}`) block with `\label`, a `\lean{...}` pin
naming the planned declaration (these do NOT exist in Lean yet — they are scaffold targets; pick
clear `AlgebraicGeometry.*` names and I will confirm them next iter), a `\uses{}`, and a one-to-
several-line informal proof. These will all live in a NEW Lean file
`AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`. Keep the existing
`lem:affine_serre_vanishing` block as the TOP of the chain (it `\uses` the new sub-lemmas).

Sub-lemmas (cut at these mathematical seams):

1. **`def:affine_cover_system`** — construction of the affine `BasisCovSystem` for `X = Spec R`
   (or an affine open of a scheme): B = the standard/distinguished opens, Cov = the standard open
   covers (finite coverings of a distinguished open by distinguished opens). The structure bundles
   the four fields; the three nontrivial ones are sub-lemmas (2)-(4) below. `\uses{def:basis_cov_system,
   lem:affine_faces_mem, lem:affine_surj_of_vanishing, lem:affine_injective_acyclic}`.

2. **`lem:affine_faces_mem`** — finite intersections of the opens of a standard cover are again
   standard/distinguished opens (condition (1) / the `faces_mem` field). Reference: Stacks Schemes
   Lemma `lemma-standard-open` ("the intersection of two standard opens is another standard open"),
   already in `references/stacks-schemes.tex` (verbatim at L514-520; `D(f) ∩ D(g) = D(fg)`). Give the
   `% SOURCE`/`% SOURCE QUOTE` block from that file.

3. **`lem:standard_cover_cofinal`** — the standard open covers of a distinguished open form a
   cofinal system among ALL its open covers. Reference: Stacks Schemes Lemma `lemma-standard-open`
   (cofinality clause, `references/stacks-schemes.tex` L558-577) together with the sheaf-on-a-basis
   cofinality principle Stacks Sheaves **Tag 009L** Lemma `lemma-cofinal-systems-coverings-standard-case`
   (now in `references/stacks-sheaves.tex` L3861-3887 — verbatim statement available; quote it).

4. **`lem:affine_surj_of_vanishing`** — discharges the `surj_of_vanishing` field for the affine
   system: for a distinguished open V and a SES `S` of `O_X`-modules with `Ȟ^{>0}(𝒰, S.X₁)=0` over
   the standard covers of V, the section map `S.X₂(V) → S.X₃(V)` is surjective. Proof: combine
   `lem:ses_cech_h1` (already done, `CechBridge.lean`) with the cofinality `lem:standard_cover_cofinal`
   so a single standard cover witnesses the surjectivity. `\uses{lem:ses_cech_h1, lem:standard_cover_cofinal}`.
   Reference: Stacks Cohomology `lemma-ses-cech-h1` (in `references/stacks-cohomology.tex`).

5. **`lem:affine_injective_acyclic`** — discharges the `injective_acyclic` field: every injective
   `O_X`-module has vanishing positive-degree Čech cohomology over the standard covers. Proof:
   `lem:injective_cech_acyclic` (done, `CechBridge.lean`) via a cover-representation bridge from the
   raw `CovDatum` (`ι → Opens X`) to the `X.OpenCover`/`coverOpen 𝒰` shape with `Finite 𝒰.I₀` that
   `injective_cech_acyclic` is stated over. Introduce that bridge as its own short
   `lem:cover_datum_bridge` (project-bespoke; no external source) if it carries real content.
   `\uses{lem:injective_cech_acyclic, lem:cover_datum_bridge}`.

6. **`lem:affine_cech_vanishing_qcoh`** — the `HasVanishingHigherCech` SEED for quasi-coherent F:
   for any quasi-coherent `O_X`-module F on the affine, the standard-cover Čech cohomology vanishes
   in positive degrees. Proof: P3's `lem:cech_acyclic_affine` (= `sectionCech_affine_vanishing`)
   gives this for the TILDE case F = ~M; reduce a general qcoh F to the tilde case via the
   isomorphism `F ≅ ~(Γ(U,F))` on an affine (Stacks Tag **01HV** `lemma-spec-sheaves`,
   `references/stacks-schemes.tex` L692-728 — `Γ(Spec R, ~M)=M`, `Γ(D(f),~M)=M_f`; and the qcoh-on-
   affine structure theorem). Mark this as the 01I8 globalisation step. If the `F ≅ ~(ΓF)` iso is
   itself nontrivial Mathlib infrastructure, give it its own `lem:qcoh_iso_tilde_sections` sub-block
   with the 01HV/01I8 source. `\uses{lem:cech_acyclic_affine, ...}`.

Finally, rewrite the **`lem:affine_serre_vanishing` proof** to: assemble the affine cover system
(1), supply the qcoh seed (6) as `HasVanishingHigherCech`, and apply
`lem:cech_to_cohomology_on_basis` (the 01EO top lemma) at each affine basic open, yielding
`H^p(U,F)=Ext^p(jShriekOU U, F)=0` for p>0. `\uses{def:affine_cover_system,
lem:affine_cech_vanishing_qcoh, lem:cech_to_cohomology_on_basis, def:absolute_cohomology}`.

## Reference anchors (all local — read and quote verbatim)
- `references/stacks-coherent.tex` — Tag 02KG `lemma-quasi-coherent-affine-cohomology-zero`
  (the top statement + the proof prose that names conditions (1)(2)(3); already quoted in the
  existing `lem:affine_serre_vanishing` block).
- `references/stacks-schemes.tex` — Schemes `lemma-standard-open` (L514-577: ∩ of standard opens +
  cofinality) and Tag 01HV `lemma-spec-sheaves` (L692-728: Γ of ~M).
- `references/stacks-sheaves.tex` — Tag 009L `lemma-cofinal-systems-coverings-standard-case`
  (L3861-3887: sheaf-on-basis via cofinal coverings).
- `references/stacks-cohomology.tex` — `lemma-ses-cech-h1`, `lemma-injective-trivial-cech`,
  Tag 01EO `lemma-cech-vanish-basis`.

## Citation discipline (mandatory)
Every NEW block deriving from a source carries `% SOURCE: <pointer> (read from references/<file>)`,
`% SOURCE QUOTE:` (verbatim, original language/notation), a visible `\textit{Source: …}` first line,
and for proofs a `% SOURCE QUOTE PROOF:` before `\begin{proof}`. Project-bespoke blocks
(`lem:cover_datum_bridge`, the `BasisCovSystem`-encoding glue) omit source lines.

## Out of scope
- Do NOT add or remove any `\leanok` (the deterministic sync owns it).
- Do NOT edit other chapters.
- Do NOT write Lean tactics; informal mathematical prose only.
- Keep `\uses{}` acyclic and matching what each sub-proof actually needs.
