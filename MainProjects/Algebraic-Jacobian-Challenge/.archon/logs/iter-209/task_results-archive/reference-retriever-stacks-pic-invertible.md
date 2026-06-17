# Reference Retriever Report

## Slug
stacks-pic-invertible

## Status
COMPLETE

Both requested Stacks source files have been downloaded, verified, and registered.
**However, the directive contained two tag misidentifications** — see "Notes for Dispatcher" below.  The content the blueprint writer actually needs IS present and located exactly.

## Sources fetched

### 1. Stacks "Modules on Ringed Spaces" chapter
- **URL**: https://raw.githubusercontent.com/stacks/stacks-project/master/modules.tex
- **Downloaded**: `references/stacks-modules.tex` (200 KB, verified: starts with `\input{preamble}`)
- **Pointer**: `references/stacks-modules.md`
- **Tag 01CR confirmed inside this file**:
  - Section 17.25 "Invertible modules", lines **4038–4411**
  - `\label{definition-invertible}` (tag **01CS**) — line **4047** — defines invertible module via tensor-functor equivalence
  - `\label{lemma-invertible}` (tag **0B8K**) — line **4067** — equivalent conditions: (1) invertible; (2) ∃ $\mathcal{N}$, $\mathcal{L}\otimes_{\mathcal{O}_X}\mathcal{N}\cong\mathcal{O}_X$
  - `\label{lemma-invertible-is-locally-free-rank-1}` (tag **0B8M**) — line **4160** — locally free rank-1 ↔ invertible (when stalks local)
  - `\label{lemma-constructions-invertible}` — line **4201** — tensor product of invertibles is invertible; dual is invertible
  - `\label{definition-pic}` (tag **01CX**) — line **4351** — Picard group $\Pic(X)$: abelian group of isomorphism classes of invertible $\mathcal{O}_X$-modules, addition = tensor product

### 2. Stacks "Divisors" chapter
- **URL**: https://raw.githubusercontent.com/stacks/stacks-project/master/divisors.tex
- **Downloaded**: `references/stacks-divisors.tex` (366 KB, verified: starts with `\input{preamble}`)
- **Pointer**: `references/stacks-divisors.md`
- Tag 01CR is **NOT** in this file (see Notes).  Useful for the Cartier/Weil divisor material: §31.28 (line 6707) map $c_1:\Pic(X)\to\text{Cl}(X)$, §31.29 (line 6961) Picard groups of UFDs and $\mathbf{P}^n$.

## Index updates
- `references/summary.md` — appended 2 entries: `stacks-modules`, `stacks-divisors`

## Notes for Dispatcher

**Critical tag corrections — the directive contained two misidentifications:**

1. **Tag 01CR** — the directive says "the section in the Stacks *Divisors* chapter".
   This is wrong.  The Stacks tags file gives `01CR → modules-section-invertible`.
   Tag 01CR is **Section 17.25 of the Modules on Ringed Spaces chapter** (`modules.tex`),
   not the Divisors chapter.  The content is exactly what the blueprint writer needs
   (invertible-module definition + Pic(X) abelian group), just in the right file.

2. **Tag 01HK** — the directive says "Invertible modules (Modules on Sites / Modules)".
   This is completely wrong.  The tags file gives:
   `01HK → schemes-definition-closed-immersion-locally-ringed-spaces`
   Tag 01HK is Definition 26.4.1 in the Schemes chapter: a closed immersion of
   locally ringed spaces (homeomorphism onto closed subset + surjective $\mathcal{O}_X \to i_*\mathcal{O}_Z$ + locally generated kernel).
   It has nothing to do with invertible modules or the Picard group.

**The correct tags for the `IsInvertible` predicate and `Pic(X)` group law are:**
| Tag | Label | Location in stacks-modules.tex | Content |
|-----|-------|-------------------------------|---------|
| **01CR** | `modules-section-invertible` | line 4038 (section header) | The whole §17.25 section |
| **01CS** | `modules-definition-invertible` | line 4047 | Definition: invertible via tensor-equivalence functor |
| **0B8K** | `modules-lemma-invertible` | line 4067 | Characterisation: invertible ↔ ∃N, L⊗N≅𝒪 |
| **0B8M** | `modules-lemma-invertible-is-locally-free-rank-1` | line 4160 | loc. free rank-1 ↔ invertible |
| **01CX** | `modules-definition-pic` | line 4351 | Picard group as abelian group |

**Sites-modules analogues** (for sheaves on a site, if needed):
- Tag 0408 = `sites-modules-section-invertible`
- Tag 0409 = `sites-modules-definition-invertible-sheaf`
- Tag 0B8N = `sites-modules-lemma-invertible` (∃N characterisation on a site)
These are in `sites-modules.tex` (not yet downloaded; the URL would be
`https://raw.githubusercontent.com/stacks/stacks-project/master/sites-modules.tex`).
