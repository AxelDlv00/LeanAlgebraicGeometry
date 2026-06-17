# Stacks Project — Modules on Ringed Spaces (modules.tex)

## Citation
The Stacks Project Authors, "Stacks Project", https://stacks.math.columbia.edu, Chapter 17 "Modules on Ringed Spaces".
https://raw.githubusercontent.com/stacks/stacks-project/master/modules.tex

## Slug
stacks-modules

## Retrieval status
RETRIEVED — 2026-05-30

## Local source files
- references/stacks-modules.tex — LaTeX source, VERIFIED (starts with `\input{preamble}`, 200 KB) — retrieved from https://raw.githubusercontent.com/stacks/stacks-project/master/modules.tex

## Why this source
A blueprint chapter (`Picard_TensorObjSubstrate.tex`) needs verbatim TeX for the
invertibility predicate `IsInvertible M := ∃ N, M ⊗ N ≅ 𝒪` and the abelian-group
structure on `Pic(X)`.  Both live in Section 17.25 of this chapter (tag 01CR).

## Contents map

Section numbering is the Stacks Project's own (Chapter 17 of the Stacks Project).

- §17.1  Introduction — line 17
- §17.2  Pathology — line 37
- §17.3  The abelian category of sheaves of modules — line 59
- …
- **§17.25  Invertible modules** — **tag 01CR** — **lines 4038–4411**
  - Definition 17.25.1 `\label{definition-invertible}` — **tag 01CS** — **line 4047**
    An invertible $\mathcal{O}_X$-module: sheaf $\mathcal{L}$ such that
    $\mathcal{F} \mapsto \mathcal{L} \otimes \mathcal{F}$ is an equivalence of categories.
  - Lemma 17.25.2 `\label{lemma-invertible}` — **tag 0B8K** — **line 4067**
    Characterisation: $\mathcal{L}$ invertible ↔ ∃ $\mathcal{N}$ with
    $\mathcal{L} \otimes_{\mathcal{O}_X} \mathcal{N} \cong \mathcal{O}_X$
    (the $\exists N$ condition the blueprint writer needs for `IsInvertible`).
  - Lemma 17.25.3 `\label{lemma-pullback-invertible}` — **tag** (unnamed here) — **line 4143**
    Pullback of invertible is invertible.
  - Lemma 17.25.4 `\label{lemma-invertible-is-locally-free-rank-1}` — **tag 0B8M** — **line 4160**
    Locally free rank-1 ↔ invertible (when stalks are local).
  - Lemma 17.25.5 `\label{lemma-constructions-invertible}` — **line 4201**
    Tensor product of invertibles is invertible; dual is invertible.
  - Definition 17.25.6 `\label{definition-powers}` — **tag 01CU** — **line ~4222**
    Tensor powers $\mathcal{L}^{\otimes n}$ for $n \in \mathbf{Z}$.
  - Lemma 17.25.7 `\label{lemma-pic-set}` — **tag 01CW** — **line 4315**
    Isomorphism classes of invertible sheaves form a set.
  - **Definition 17.25.8** `\label{definition-pic}` — **tag 01CX** — **line 4351**
    The Picard group $\Pic(X)$: abelian group of isomorphism classes of invertible
    $\mathcal{O}_X$-modules, addition = tensor product.
- §17.26  Rank and determinant — line 4412
- …

## Caveats

**Tag 01CR is in THIS file (modules.tex), NOT in divisors.tex.**
The directive for slug `stacks-pic-invertible` cited the "Divisors" chapter as
the location of 01CR ("Picard groups of schemes"), but the Stacks tags file
confirms `01CR → modules-section-invertible`.  The Picard-group definition sits
inside the "Invertible modules" section of the "Modules on Ringed Spaces" chapter.

**Tag 01HK is unrelated to invertible modules.**
The directive also listed 01HK as "Invertible modules (Modules on Sites / Modules)".
The Stacks tags file gives `01HK → schemes-definition-closed-immersion-locally-ringed-spaces`
(Definition 26.4.1, closed immersion of locally ringed spaces).  01HK has nothing to
do with line bundles or the Picard group.

For the `sites-modules` analogue (sheaves on a site), see:
- Tag 0408 = `sites-modules-section-invertible` — parallel section in sites-modules.tex
- Tag 0409 = `sites-modules-definition-invertible-sheaf`
- Tag 0B8N = `sites-modules-lemma-invertible` (∃N characterisation on a site)

## Quality / provenance
Authoritative: fetched verbatim from the master branch of the official Stacks Project
GitHub repository (stacks/stacks-project).  The tag assignments are confirmed against
the project's own `tags/tags` file.
