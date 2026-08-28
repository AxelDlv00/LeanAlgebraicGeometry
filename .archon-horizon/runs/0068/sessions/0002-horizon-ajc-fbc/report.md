All four files are committed and byte-identical to the ledger. Task status left non-terminal so it returns to the queue.

## Summary

I did not close flat base change. I proved a different long-open theorem outright, converted the priority obligation into one named statement, and closed the leak *mechanism* the task was really about.

## Progress

- `Cohomology/TildeExactness.lean`: **1 open target → 0, entirely sorry-free.** `tildePreservesFiniteLimits` (Stacks 01HV, blueprint `lem:tilde_preserves_kernels`) proved, with `tilde_preservesMonomorphisms` and `tilde_preservesHomology`. Route: basic opens, not stalks — mathlib already exhibits `Γ(M~, D(r))` as a localisation of `M`, so the section map of `~f` *is* `IsLocalizedModule.map f`, injective because localisation is flat. The file's header had prescribed a stalk route at 100–150 LOC; none of that machinery was needed, and I corrected the header rather than leave it to mislead the next session.
- `Cohomology/CechHigherDirectImageUnconditional.lean`: **3 sorries → 3 sorries**, plus 9 sorry-free lemmas. `pullback_preservesFiniteLimits` is no longer a `sorry`-bodied instance — it derives from the single named carrier `pullback_preservesMonomorphisms`. New: right-exact + mono-preserving ⟹ left-exact; monos of `𝒪_X`-modules are sectionwise both ways; mono-checking is cover-local; the open-immersion case and the affine-on-tilde-image case of flat mono-preservation.
- `scripts/axiom-frontier.lean`: §2 claimed "the two `sorry`-bodied INSTANCES … 2 instance = 26". Re-derived with the file's own census: **21 theorem + 7 def + 0 instance = 28**. Also replaced the flat-pullback probe, which my own de-instancing had made *vacuously clean* — it measured the identity morphism, where a cheaper clean path appeared.
- Blueprint: five `\leanok` added, two removed, the flat-exactness node restructured onto the mono route with the old route kept as a remark saying why it isn't used.

## Issues

- **The leak is still there.** Frontier 126/85/41 → 147/95/52, and **no previously-contaminated declaration became clean**. The movement is other lanes' commits plus my own probe lines. The task's headline did not happen.
- **The ledger race hit me**: commit `b18d4a9a0` swept in three Rebuild files. Nothing lost (HEAD matched the worktree), so I did not revert. I found the fix — `commit -- <paths>` bypasses the shared index — and every later commit is a clean single-file diff; another lane adopted it.
- Two of the project's three audit instruments were silently measuring nothing today, for the same structural reason. I fixed `axiom-frontier`; `leanok-audit`'s positive control has gone stale because someone proved it, filed as I-0545 rather than touching another lane's file.
- I held two `\leanok` marks to a stricter standard than six others in the same chapter — conservative but inconsistent, flagged on the thread.
- The final full build was cut off by my own 10-minute timeout at job 8763/8767; an earlier failure was a concurrent writer's file in `RiemannRoch/Adelic`. My two modules build clean alone (2896 jobs, exit 0).

## Why I stopped

**Partly advanced, not complete.** All three task obligations remain open: I never attempted the two Čech naturality squares, and flat exactness is reduced rather than proved. No terminal status set.

Three of four ingredients for `pullback_preservesMonomorphisms` now exist sorry-free. The gap: the affine case holds only on the tilde image — quasi-coherent modules — while the statement quantifies over all of them, and over an affine base `Scheme.Modules` is strictly larger than `ModuleCat`.

## Next

Mono-preservation for the **affine** pullback on arbitrary modules. Don't retry the presheaf-pullback/sheafification route — its outer factors already synthesise, so the categorical glue was never the gap, and its middle factor needs the same missing stalk model.
