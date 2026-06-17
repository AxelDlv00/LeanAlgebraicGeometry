# Blueprint-clean report — iter-022

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Scope:** Four new/edited blocks from the blueprint-writer round:
`lem:section_cech_objd_apply`, `lem:section_cech_coface_match`,
`lem:section_cech_ab_exact`, `lem:section_cech_product_equiv`.

---

## Changes made

### 1. `lem:section_cech_coface_match` — statement purity

**Old:** "... with an \(R\)-module \(M\) **(the active target; see the note below on a general quasi-coherent \(\mathcal{F}\))**."

**New:** "... with an \(R\)-module \(M\) (for a general quasi-coherent \(\mathcal{F}\), see the note following the statement)."

Rationale: "active target" is project-progress language; replaced with a timeless parenthetical directing the reader to the note.

---

### 2. `% NOTE:` following `lem:section_cech_coface_match` — project-history & implementation-type removal

**Removed language:**
- "the active target is the tilde case" (project-progress)
- "the per-coordinate AddEquiv to LocalizedModule" (Lean implementation type `AddEquiv`)
- "separately-deferred globalisation gap recorded in def:qcoh_sections_localized" (project-history)

**Replacement:** Restated as timeless mathematics:
> For the tilde case \(\mathcal{F} = \widetilde{M}\) the per-coordinate comparison isomorphism and the naturality square follow directly from `qcohRestriction_eq_comparison`. For a general quasi-coherent \(\mathcal{F}\), reduce to the tilde case via \(\mathcal{F} \cong \widetilde{\Gamma\mathcal{F}}\) (Stacks Tag 01I8), the affine equivalence \(\operatorname{QCoh}(\operatorname{Spec} R) \simeq \operatorname{Mod}(R)\), which is the open gap recorded in Definition~\ref{def:qcoh_sections_localized}.

Mathematical content is fully preserved; only framing language changed.

---

### 3. `lem:section_cech_coface_match` proof — last paragraph replacement

**Removed (Lean-implementation paragraph):**
> "The infrastructure this step owns is the accessor reconciliation: the section {\v C}ech complex reads sections through the \(\mathrm{Ab}\)-valued accessor `((toPresheafOfModules(Spec R)).obj F).presheaf.obj(op(D(s_σ)))`, whereas the proved localisation facts of Definition~\ref{def:qcoh_sections_localized} are stated for the \(\operatorname{ModuleCat}\)-valued sections of `modulesSpecToSheaf` / `tilde.toOpen`. Reconciling these two views ... into the single \(\operatorname{AddEquiv}\) \(\varphi_\sigma\) ..."

Problems: "infrastructure this step owns", raw Lean term path `(toPresheafOfModules(...)).obj.presheaf.obj(op(...))`, `Ab`-valued vs `ModuleCat`-valued framing, `AddEquiv` — all implementation-level language.

**Replacement (timeless mathematics):**
> The isomorphism \(\varphi_\sigma\) is obtained by matching the two descriptions of the sections of \(\widetilde{M}\) over \(D(s_\sigma)\): the cosimplicial functor provides one description and the localisation property of Definition~\ref{def:qcoh_sections_localized} provides the other. Their agreement, together with the naturality square, is the content of this bridge.

---

### 4. `lem:section_cech_product_equiv` statement — proof-strategy rationale removal

**Removed tail:** "so that downstream proofs may rewrite by it without unfolding the \(\operatorname{Concrete.productEquiv}\) coercion."

Rationale: "downstream proofs may rewrite by it without unfolding" is proof-assistant strategy language, not mathematics. The definitional restatement of `sectionCechProductEquiv_apply` is described mathematically; the implementation motivation for its existence is not blueprint content.

---

## Unchanged blocks

- `lem:section_cech_objd_apply` — already clean; all names reference canonical mathematical operations.
- `lem:section_cech_ab_exact` — "discharges that hypothesis" and "It chains [lemma1], [lemma2]" are informal blueprint proof-sketch language, not tactic strings; left as-is.
- All FreePresheafComplex / P4 / P5 blocks — not touched.
- All `\leanok` markers — not touched.

---

## Tilde-bridge prose verification

`lem:section_cech_coface_match` proof step (ii) "Tilde \(\mathcal{F}\)-bridge" reads as timeless mathematics:

1. **Per-coordinate localisation isomorphism φ_σ** — uniquely determined by the two `IsLocalizedModule` structures (both localise \(M\) at \(\operatorname{Submonoid.powers}(s_\sigma)\)), established via `IsLocalizedModule.iso` and uniqueness `AwayComparison.comparison_unique`. ✅ No implementation TODO.

2. **Naturality square** — \(\varphi_\sigma \circ \operatorname{sectionCechFaceRestr}(\sigma, i) = \operatorname{dCoface} \circ \varphi_{\sigma \circ d_i}\) is exactly `qcohRestriction_eq_comparison` from Definition~\ref{def:qcoh_sections_localized}: the presheaf restriction of \(\widetilde{M}\) equals the away-localisation comparison. ✅ Timeless.

---

## Citation discipline

No missing `% SOURCE QUOTE` entries found. The four lemmas are technical intermediates derived from:
- `def:qcoh_sections_localized` (already cites Stacks 01HV items (4)–(5))
- `lem:section_cech_homology_exact` (already cites Stacks `lemma-cech-cohomology-quasi-coherent-trivial`)

Neither sub-lemma is a direct Stacks statement; no new verbatim quotes required. The Stacks 01HV quote already present in `def:qcoh_sections_localized` covers the localisation-of-sections facts referenced throughout.

---

## Status

**PASS** — Chapter is purity-clean in all four target blocks. No `\leanok` altered. No FreePresheafComplex/P4/P5 blocks touched. Citation discipline satisfied.
