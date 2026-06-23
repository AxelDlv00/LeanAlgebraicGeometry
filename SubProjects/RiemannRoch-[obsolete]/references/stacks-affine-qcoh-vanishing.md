# Stacks Project — Affine Qcoh Cohomology Vanishing (Čech route)

## Citation
The Stacks Project Authors, "Cohomology of Sheaves" (`cohomology.tex`) and
"Cohomology of Schemes" (`coherent.tex`), The Stacks Project,
https://stacks.math.columbia.edu (retrieved 2026-06-22).
Tags: **01EJ**, **01EO**, **01EW** (cohomology.tex); **01XB**, **01XJ** (coherent.tex).

## Slug
stacks-affine-qcoh-vanishing

## Retrieval status
RETRIEVED — 2026-06-22

## Local source files
- `references/stacks-affine-qcoh-vanishing-cohomology.tex` — LaTeX source, VERIFIED via `file` (14535 lines) — retrieved from https://raw.githubusercontent.com/stacks/stacks-project/master/cohomology.tex
- `references/stacks-affine-qcoh-vanishing-coherent.tex` — LaTeX source, VERIFIED via `file` (8138 lines) — retrieved from https://raw.githubusercontent.com/stacks/stacks-project/master/coherent.tex
- `references/stacks-tags.txt` — full tag→label mapping file (947K), VERIFIED — retrieved from https://raw.githubusercontent.com/stacks/stacks-project/master/tags/tags

## Why this source
S2's `HModule_affine_acyclic` (R^pΓ vanishing of a qcoh sheaf on an affine, p>0)
must be built flasque-free. The direct distinguished-open Čech/Koszul computation
is the realistic route; the blueprint-writer and a later mathlib-build prover need
the verbatim Stacks statements and proofs.

## Contents map

### cohomology.tex — "Cohomology of Sheaves"

| Tag | Label | Location | Content |
|-----|-------|----------|---------|
| **01EJ** | `lemma-cech-exact-presheaves` | line 1048–1063 | The Čech complex functor $\check{\mathcal{C}}^\bullet(\mathcal{U},-)$ on **presheaves** is exact. |
| **01EO** | `section-cech-cohomology-cohomology` | line 1404 (section header) | Section "Čech cohomology and cohomology" — contains the comparison map $\check{H}^\bullet \to H^\bullet$ and the Čech-to-derived spectral sequence. Key lemmas in the section: `lemma-injective-trivial-cech` (line 1407), `lemma-cech-cohomology` (line 1433, the canonical map $\check{C}^\bullet \to R\Gamma$). |
| **01EW** | `lemma-cech-vanish-basis` | line 1695–1776 | **Acyclic-cover vanishing theorem.** Given a basis $\mathcal{B}$ and a cofinal set $\text{Cov}$ of coverings with $\check{H}^p(\mathcal{U},\mathcal{F})=0$ for $p>0$ and all $\mathcal{U}\in\text{Cov}$, conclude $H^p(U,\mathcal{F})=0$ for all $p>0$ and $U\in\mathcal{B}$. Proof: embed into injective, use injective-trivial-Čech (01EO region), get long-exact on Čech + induction on degree. **This is the key "Čech acyclicity implies derived acyclicity" lemma.** |
| 01FG | `section-alternating-cech` | line 4071 | Section on the alternating Čech complex (comparison with ordinary Čech). |

#### Section map (cohomology.tex)
- §"Introduction" — line 17
- §"Cohomology of sheaves" — line 32 (injective resolution definition)
- §"Derived functors" — line 92
- §"The Čech complex and Čech cohomology" — line 868
- §"Čech cohomology as a functor on presheaves" — line 1011
- §"**Čech cohomology and cohomology**" (**01EO**) — line 1404 ← main region
  - Lemma `lemma-injective-trivial-cech` — line 1407 (injective ⇒ Čech-acyclic)
  - Lemma `lemma-cech-cohomology` — line 1433 (canonical map Čech→derived)
  - Lemma **01EJ** `lemma-cech-exact-presheaves` — line 1048 (in prior §)
  - Lemma **01EW** `lemma-cech-vanish-basis` — line 1695 ← acyclic-cover thm
- §"Flasque sheaves" — line 1881
- §"The Leray spectral sequence" — line 2088
- §"The alternating Čech complex" (01FG) — line 4071

### coherent.tex — "Cohomology of Schemes"

| Tag | Label | Location | Content |
|-----|-------|----------|---------|
| (no tag) | `lemma-cech-cohomology-quasi-coherent-trivial` | line 44–135 | **Čech exactness on standard covers (Koszul homotopy).** For $\mathcal{U}: U=\bigcup D(f_i)$ a standard cover of affine $U=\operatorname{Spec}A$ and $\mathcal{F}=\widetilde{M}$, the extended Čech complex $0\to M\to\prod M_{f_{i_0}}\to\prod M_{f_{i_0}f_{i_1}}\to\cdots$ is exact. Proof: localize at $\mathfrak{p}$, pick $i_{\text{fix}}$ with $f_{i_{\text{fix}}}\notin\mathfrak{p}$, and exhibit explicit contraction homotopy $h(s)_{i_0\ldots i_p}=s_{i_{\text{fix}}i_0\ldots i_p}$ showing $dh+hd=\mathrm{id}$. |
| **01XB** | `lemma-quasi-coherent-affine-cohomology-zero` | line 145–174 | **Serre vanishing (affine qcoh cohomology = 0).** For any scheme $X$, qcoh $\mathcal{F}$, and affine open $U\subset X$: $H^p(U,\mathcal{F})=0$ for all $p>0$. Proof: apply **01EW** with basis = affine opens, $\text{Cov}$ = standard open coverings; condition (3) follows from `lemma-cech-cohomology-quasi-coherent-trivial`; cofinality from `schemes-lemma-standard-open`. |
| **01XJ** | `lemma-quasi-coherence-higher-direct-images` | line 741–841 | For $f:X\to S$ quasi-compact quasi-separated: (1) $R^pf_*\mathcal{F}$ is qcoh; (2)–(3) bounded vanishing. Proof uses induction principle + Mayer-Vietoris + **01XB**. |

#### Section map (coherent.tex)
- §"Introduction" — line 17
- §"**Čech cohomology of quasi-coherent sheaves**" — line 32 ← main region
  - `lemma-cech-cohomology-quasi-coherent-trivial` — line 44 (Koszul homotopy)
  - **01XB** `lemma-quasi-coherent-affine-cohomology-zero` — line 145 (Serre vanishing)
  - `lemma-relative-affine-vanishing` — line 180 (relative version)
  - `lemma-cech-cohomology-quasi-coherent` — line 246 (Čech = derived for qcoh + separated)
- §"Vanishing of cohomology" — line 272 (Serre's criterion for affineness)
- §"Finiteness of cohomology" — (later, Noetherian section)
- **01XJ** `lemma-quasi-coherence-higher-direct-images` — line 741 (higher direct images qcoh)

## Dependency chain for HModule_affine_acyclic

```
lemma-cech-cohomology-quasi-coherent-trivial  (coherent.tex l.44)
  — Koszul homotopy ⟹ Čech of qcoh on standard cover is exact
  ↓ used as condition (3) in:
01EW lemma-cech-vanish-basis  (cohomology.tex l.1695)
  — acyclic-cover principle: vanishing Čech on cofinal basis ⟹ vanishing derived H^p
  ↓ applied with basis = affine opens, Cov = standard covers in:
01XB lemma-quasi-coherent-affine-cohomology-zero  (coherent.tex l.145)
  — H^p(U, F) = 0 for p > 0, U affine, F quasi-coherent  ← GOAL
```

Supporting tags for the acyclic cover argument:
- 01EJ `lemma-cech-exact-presheaves` (cohomology.tex l.1048): Čech is exact on presheaves (used to get long-exact on Čech in 01EW proof).
- 01EO section (cohomology.tex l.1404): canonical map Čech→derived; injective ⇒ Čech-acyclic (lemma-injective-trivial-cech).

## Caveats
- Tag 01XJ (`lemma-quasi-coherence-higher-direct-images`) is the **higher direct images qcoh** result, not an alternating-Čech lemma. The directive description "alternating Čech complex / its exactness" does not match the actual content of 01XJ; that tag is a downstream consequence of 01XB (qcoh of affines vanishes) and is about quasi-coherence of $R^pf_*$. The alternating Čech section is 01FG.
- The key Koszul-homotopy lemma (`lemma-cech-cohomology-quasi-coherent-trivial`, coherent.tex l.44) has **no Stacks tag** — it precedes 01XB in the same section.
- To navigate: use `Read` with `offset`/`limit` on the `.tex` files at the line numbers in this map.

## Quality / provenance
This is the primary Stacks Project source, fetched verbatim from the official GitHub mirror.
The `tags/tags` file confirms the tag→label mapping. These are authoritative.
