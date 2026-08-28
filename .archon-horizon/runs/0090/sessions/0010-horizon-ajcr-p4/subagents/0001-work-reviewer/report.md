You are auditing lane `ajcr-p4`'s work this session in the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon, project MainProjects/Algebraic-Jacobian-Challenge-Rebuild.

WHAT I DID. I claimed roadmap row `AJCR.w4-rep.datum.bot-refute` and landed a new file `AlgebraicJacobian/Picard/Pic0ChartBotRefute.lean` (rooted at AlgebraicJacobian.lean, 7 declarations, 0 sorries). Commits: ad8c39d64e, 891cb0589c, 3851a6ada7, and a docstring-only commit 3c5cee6619 that edited two OTHER lanes' files (`Pic0ChartVMonotone.lean` and `Pic0ChartRestrictedFibreSat.lean`).

THE CLAIMS I AM MAKING, each of which I want you to try to REFUTE rather than confirm:

1. `not_isLocallySurjective_restrictChart_bot` refutes the `Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc fun i => restrictChart (f i) ⊥)` instance for an ARBITRARY chart family, using no divisor data, no chart data and no `rep`.

2. `not_isLocallySurjective_restrictChart_bot'` is the same statement with ALL THREE of its antecedents (a test `T`, a section `s` on it, a point `t : T`) discharged — via `nonempty_specObj_of_field` and `specSigmaSection`. I claim it quantifies over nothing but the chart family. CHECK THIS HARD: is `specSigmaSection` actually a section of the right presheaf at the right object, or did I build something adjacent? Is it VACUOUS in the `HasDivFunctor` sense — does the statement of each of my declarations actually mention the objects it is supposedly about?

3. `false_of_isLocallySurjective_bot`: I claim ajcr-p1's existing `isLocallySurjective_of_bot` (`Pic0ChartVMonotone.lean:272`, now renumbered) is VACUOUS because its hypothesis is exactly what I refute. Verify the two propositions really are the same one (not merely similar), and that I have not overstated.

4. I claim a CONTROL: re-running my identical proof script with `⊤` in place of `⊥` FAILS at the last step, so the emptiness of `⊥` is load-bearing and this is not an accidental refutation of the seam at every `V`. Reproduce that, don't take my word.

5. I claim `CategoryTheory.FunctorToTypes.jointly_surjective'` had ZERO citations in AlgebraicJacobian/ before my file, and that no negative locally-surjective declaration existed anywhere in either main project or the six SubProjects. Test both absence claims — the workspace's memory says absence claims here are wrong more often than not, including case-sensitivity failures (a predicate in suffix position is lowerCamelCase).

6. Every declaration name I cite in a docstring: check it RESOLVES IN THAT FILE'S OWN IMPORT CLOSURE, with `#check`, not grep. I edited two upstream files to cite names in a DOWNSTREAM module, and I flagged that in the prose — verify I flagged it correctly and did not leave an unflagged one.

METHOD NOTES. Build before probing: a missing .olean makes `#print axioms` ERROR rather than pass, and I hit that once. Use `env -u GIT_INDEX_FILE lake build <Module>` from the project dir. Put scratch probes under a directory you delete afterwards, and do NOT commit anything. Verify claims against HEAD (`git --git-dir /home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git --work-tree /home/axel/LeanAlgebraicGeometry-Horizon show HEAD:<path>`) as well as disk, since ten lanes share this ledger. Note that `lake build AlgebraicJacobian` (the ROOT) is currently RED for a reason that is not mine: HEAD roots `Pic0AtlasFromDivRepAff` whose source is not committed (ajcr-p2 mid-edit). Build individual modules instead.

Report: which of my six claims survive, which are refuted or overstated, and anything I should have measured and did not. Be specific with file:line. I would rather hear that a headline is wrong now than have a human find it.
