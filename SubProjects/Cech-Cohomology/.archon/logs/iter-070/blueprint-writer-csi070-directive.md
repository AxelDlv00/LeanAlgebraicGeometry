# blueprint-writer directive — slug csi070

Target chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated; covers
`AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`).

Context: the iter-067 prover closed `hcompat` and built the CANONICAL augmentation of the concrete
section Čech complex, replacing the free-parameter form (a free `ε` made the old scaffold statement
FALSE; the consumer `hSec` in `CechAugmentedResolution.lean` calls with no `ε`). Two new Lean decls
exist with NO blueprint entry (coverage debt), and two existing blocks describe the obsolete
free-`ε` form. Three actions:

## 1. New blocks (place immediately before `lem:cechSection_complex_iso`)

- `\begin{definition}` label `def:sectionCechAugV`, `\lean{AlgebraicGeometry.sectionCechAugV}`.
  Statement: the canonical augmentation \(\varepsilon : \Gamma(V,\mathcal F) \to \prod_i
  \Gamma(U_i \cap V, \mathcal F)\) of the concrete section Čech complex over the restricted family
  \(U_i \cap V\): it is the evaluation at \(V\) of the Čech augmentation
  \(\mathcal F \to \mathcal C^0\) (def:cech_augmentation), transported across the degree-0 object
  isomorphism of Lemma coreIso_obj_iso. Statement `\uses{lem:coreIso_obj_iso, def:cech_augmentation}`.
  One-line informal proof/justification (a definition: composition of the evaluated augmentation with
  `(coreIso_objIso 𝒰 F 0 V).hom`).
- `\begin{lemma}` label `lem:sectionCechAugV_comp_d`, `\lean{AlgebraicGeometry.sectionCechAugV_comp_d}`.
  Statement: \(\varepsilon \cdot d^0 = 0\) for the canonical augmentation. Statement
  `\uses{def:sectionCechAugV, lem:cech_augmentation_comp_d, lem:coreIso_comm}` (the Lean proof
  transports the evaluated augmentation identity across the degree-0/1 squares of the differential
  identification, so it genuinely uses the coreIso commutation). Short informal proof: conjugating
  \(\varepsilon\cdot d^0\) by the object isos turns it into the evaluation at \(V\) of the augmented-complex
  identity \(\mathcal F \to \mathcal C^0 \to \mathcal C^1 = 0\) (lem:cech_augmentation_comp_d).

## 2. Sync the two obsolete statements to the canonical augmentation

- `lem:cechSection_complex_iso`: the iso target is
  \(D'_{\mathrm{aug}} = \check{\mathcal C}^\bullet(\mathcal U',\mathcal F).\mathrm{augment}\,
  \varepsilon_{\mathrm{can}}\, h_{\mathrm{can}}\) with the CANONICAL \(\varepsilon_{\mathrm{can}}\) of
  def:sectionCechAugV (NOT a free parameter — for a non-canonical \(\varepsilon\) the statement is
  false). Update the prose + the stale `% NOTE: the prover re-signs…` comment (the re-signing
  happened iter-067) + add `def:sectionCechAugV, lem:sectionCechAugV_comp_d` to the STATEMENT
  `\uses`. Also record that the degree-0 compatibility (`hcompat`) is now definitional: the canonical
  augmentation is BY CONSTRUCTION the transported evaluated augmentation.
- `lem:cechSection_contractible`: same sync — the contracted complex is the augmented complex along
  the canonical `sectionCechAugV`/`sectionCechAugV_comp_d`; both added to its STATEMENT `\uses`;
  drop the stale "prover re-signs" NOTE wording (done).

## 3. Discipline

- leandag reads STATEMENT-level `\uses` only — every dependency the Lean code uses must appear there.
- NO `\leanok` anywhere. Keep all existing `% SOURCE` quotes intact. Math prose only — no Lean tactic
  syntax in visible text.
