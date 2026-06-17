# References

<!-- archon:references-summary -->

This subproject (Line-Bundle Comparison Iso) keeps only the sources cited by
its three blueprint chapters (`Picard_LineBundlePullback`,
`Picard_TensorObjSubstrate`, `Picard_RelPicFunctor`).

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. This subproject is a carved slice of that challenge; signatures here remain authoritative for merge-back. |
| [`stacks-modules.md`](./stacks-modules.md) → `stacks-modules.tex` | Stacks ch.17 "Modules on Ringed Spaces" — **tag 01CR** = §17.25 "Invertible modules" (lines 4038–4411): Def 01CS (invertible module via tensor-equivalence functor, line 4047), Lemma 0B8K (∃N characterisation $\mathcal{L}\otimes\mathcal{N}\cong\mathcal{O}_X$, line 4067), tag 01CX (Picard group $\Pic(X)$ as abelian group under ⊗, line 4351). The primary source for `Picard_TensorObjSubstrate.tex` (invertibility, tensor-object monoidal structure, internal Hom / dual). |
| [`kleiman-picard.md`](./kleiman-picard.md) → `kleiman-picard.pdf` / `-src/*.tex` | Kleiman, "The Picard scheme" (FGA Explained / arXiv:math/0504020). Route A source for the relative Picard sheaf; backs `Picard_RelPicFunctor.tex` (§2 functor of points / sheafification of the relative Picard functor). |
| [`fga-explained.md`](./fga-explained.md) → `fga-explained.pdf` | Fantechi–Göttsche–Illusie–Kleiman–Nitsure–Vistoli, "FGA Explained" (AMS MSM 123, 2005). Collected volume; **Kleiman Picard** = Ch.9 (book p.237): §9.4 existence p.262, §9.5 Pic⁰ p.275. Companion to the arXiv `kleiman-picard` card (book numbering differs). |
